class TeaProductSubmission < ApplicationRecord
  class InvalidStatusTransition < StandardError; end

  # =====================
  # 仮想属性（フォーム用）
  # =====================
  attr_accessor :brand_name
  attr_accessor :selected_flavor_category_ids

  # =====================
  # アソシエーション
  # =====================
  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :brand, optional: true
  belongs_to :tea_product, optional: true
  belongs_to :previous_submission, class_name: "TeaProductSubmission", optional: true

  has_many :next_submissions,
           class_name: "TeaProductSubmission",
           foreign_key: :previous_submission_id,
           dependent: :nullify

  has_many :tea_product_submission_purchase_locations, dependent: :destroy
  has_many :purchase_locations, through: :tea_product_submission_purchase_locations

  has_many :tea_product_submission_flavors, dependent: :destroy
  has_many :flavors, through: :tea_product_submission_flavors

  accepts_nested_attributes_for :tea_product_submission_purchase_locations,
                                allow_destroy: true,
                                reject_if: :reject_empty_purchase_locations

  has_one_attached :image

  # =====================
  # enum
  # =====================
  enum :status, {
    draft: 0,
    pending: 10,
    rejected: 15,
    approved: 20
  }

  enum :tea_type, {
    black: 0,
    green: 10,
    oolong: 20,
    white: 30,
    herbal: 40
  }

  enum :caffeine_level, {
    caffeinated: 0,
    non_caffeinated: 10,
    decaffeinated: 20
  }

  # =====================
  # バリデーション
  # =====================
  with_options unless: :draft? do
    validates :name, presence: { message: "商品名を入力してください" }, length: { maximum: 100 }
    validates :brand, presence: { message: "ブランドを選択してください" }
    validates :tea_type, presence: { message: "お茶の種類を選択してください" }
    validates :caffeine_level, presence: { message: "カフェインの有無を選択してください" }

    validate :at_least_one_flavor
    validate :validate_purchase_locations
    validate :brand_must_be_published_or_pending_with_self
  end

  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :rejection_reason, presence: true, if: :rejected?

  validate :image_type

  # =====================
  # ステータス操作
  # =====================

  def submit!
    raise InvalidStatusTransition unless draft?

    self.status = :pending

    raise ActiveRecord::RecordInvalid, self unless valid?

    save!
  end

  def approve!(admin)
    raise InvalidStatusTransition unless pending?

    transaction do
      product = tea_product || build_tea_product(user: user)

      # 本体更新
      product.assign_attributes(
        name: name,
        description: description,
        brand: brand,
        tea_type: tea_type,
        caffeine_level: caffeine_level,
        status: :published, # 公開状態にする
        approved_by: admin,
        approved_at: Time.current
      )

      # フレーバー同期
      product.flavor_ids = flavor_ids

      # 購入場所同期
      product.purchase_locations = purchase_locations

      # 画像の同期
      product.image.attach(image.blob) if image.attached?

      product.save!

      update!(
        status: :approved,
        approved_by: admin,
        approved_at: Time.current,
        tea_product: product
      )
    end
  end

  def reject!(admin, reason:)
    raise InvalidStatusTransition unless pending?

    update!(
      status: :rejected,
      approved_by: admin,
      approved_at: Time.current,
      rejection_reason: reason
    )
  end

  # =====================
  # 再申請（コピー）
  # =====================
  def build_resubmission
    transaction do
      new_submission = dup

      new_submission.assign_attributes(
        status: :draft,
        previous_submission_id: id,
        rejection_reason: nil,
        approved_at: nil,
        approved_by: nil
      )

      # 画像のコピー
      new_submission.image.attach(image.blob) if image.attached?

      new_submission.save!

      # フレーバーコピー
      new_submission.flavor_ids = flavor_ids

      # 購入場所コピー
      tea_product_submission_purchase_locations.each do |tpl|
        new_submission.tea_product_submission_purchase_locations.create!(
          purchase_location: tpl.purchase_location
        )
      end

      new_submission
    end
  end

  # =====================
  # ブランド解決
  # =====================
  def resolve_brand!(brand_id:, brand_name:)
    if brand_id.present?
      self.brand = Brand.find(brand_id)
    elsif brand_name.present?
      self.brand = Brand.create_or_find_by!(name_ja: brand_name) do |b|
        b.status = :draft
        b.user = user
      end
    else
      # どちらも空の場合は何もしない
      self.brand = nil 
    end
  end

  # =====================
  # private
  # =====================
  private

  def at_least_one_flavor
    errors.add(:base, "フレーバーを1つ以上選択してください") if flavors.empty?
  end

  def validate_purchase_locations
    active = tea_product_submission_purchase_locations.reject(&:marked_for_destruction?)

    if active.empty?
      errors.add(:base, "購入場所を1件登録してください")
    elsif active.size > 3
      errors.add(:base, "購入場所は3件まで登録できます")
    end
  end

  def brand_must_be_published_or_pending_with_self
    return if brand.blank?
    return if brand.published?

    if (brand.pending? || brand.draft?) && brand.user_id == user_id
      return
    end

    errors.add(:brand, "は承認済み、または申請中のものを選択してください")
  end

  def reject_empty_purchase_locations(attributes)
    return false if attributes["id"].present?

    loc_attrs = attributes["purchase_location_attributes"] || {}

    return false if attributes["purchase_location_id"].present?

    loc_attrs["name"].blank? && loc_attrs["location_type"].blank?
  end

  def image_type
    return unless image.attached?

    unless image.content_type.in?(%w[image/png image/jpeg image/webp])
      errors.add(:image, "はPNG/JPEG/WEBPのみ対応しています")
    end

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以内にしてください")
    end
  end
end
