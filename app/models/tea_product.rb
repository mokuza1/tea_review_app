class TeaProduct < ApplicationRecord
  class InvalidStatusTransition < StandardError; end

  attr_accessor :brand_name
  attr_accessor :selected_flavor_category_id

  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :brand, optional: true

  has_many :tea_product_flavors, dependent: :destroy
  has_many :flavors, through: :tea_product_flavors
  has_many :tea_product_purchase_locations, dependent: :destroy
  has_many :purchase_locations, through: :tea_product_purchase_locations

  enum :status, {
    draft: 0,
    pending: 10,
    rejected: 15,
    published: 20
  }

  enum :tea_type, {
    leaf: 0,
    tea_bag: 10,
    powder: 20,
    liquid: 30,
    bottle: 40
  }

  enum :caffeine_level, {
    caffeinated: 0,
    non_caffeinated: 10,
    decaffeinated: 20
  }

  validates :name, presence: { message: "を入力してください" }, length: { maximum: 100 }, unless: :draft?
  validates :brand, presence: { message: "を選択してください" }, unless: :draft?
  validates :tea_type, presence: { message: "を選択してください" }, unless: :draft?
  validates :caffeine_level, presence: { message: "を選択してください" }, unless: :draft?
  # validates :selected_flavor_category_id,  presence: true,  unless: :draft?
  validates :description, length: { maximum: 1000 }, allow_blank: true

  validate :brand_must_be_published_or_pending_with_self, unless: :draft?
  validate :at_least_one_flavor, unless: :draft?
  validate :flavors_belong_to_selected_category, unless: :draft?
  validate :only_one_purchase_location

  # コールバック
  # before_save :set_approved_at, if: :will_be_published?

  # TeaProduct認可ロジック
  scope :viewable_by, ->(user) {
  if user
    where(status: statuses[:published])
      .or(where(user_id: user.id))
  else
    published
  end
  }

  def status_i18n
    enum_i18n(:status)
  end

  # ===========
  # 一般ユーザー側
  # ===========

  # rejected 状態の商品を編集したら draft に戻す
  def update_with_resubmission!(params)
    transaction do
      update!(params)
      update!(status: :draft) if rejected?
    end
  end

  def submit
    return false unless draft?
    return false unless valid?

    self.status = :pending
    save
  end

  # ===========
  # 管理者側
  # ===========

  def approve!(admin)
    raise InvalidStatusTransition unless pending?

    update!(
      status: :published,
      approved_by: admin,
      approved_at: Time.current
    )
  end

  def reject!(admin)
    raise InvalidStatusTransition unless pending?

    update!(
      status: :rejected,
      approved_by: admin,
      approved_at: Time.current
    )
  end

  private

  def set_approved_at
    self.approved_at = Time.current
  end

  def will_be_published?
    # statusがpublishedに変更される時だけtrueを返す
    status_changed? && published?
  end

  # Brand は published または同時申請（pending）中のみ許可
  def brand_must_be_published_or_pending_with_self
    return if brand.blank?

    return if brand.published?
    return if brand.pending? # SubmitTeaProductService 経由を想定

    errors.add(:brand, "は承認済み、または申請中のものを選択してください")
  end

  def at_least_one_flavor
    if flavors.empty?
      errors.add(:base, "フレーバーを1つ以上選択してください")
    end
  end

  # フレーバーは選択した大カテゴリに属している必要あり
  def flavors_belong_to_selected_category
    return if flavors.empty?

    category_ids = flavors.map(&:flavor_category_id).uniq

    if category_ids.size > 1
      errors.add(:base, "フレーバーは同一カテゴリ内で選択してください")
    end
  end

  def only_one_purchase_location
    if tea_product_purchase_locations.reject(&:marked_for_destruction?).size > 1
      errors.add(:base, "購入場所は1件のみ登録できます")
    end
  end

  # def validate_for_submit!
    # raise ActiveRecord::RecordInvalid, self unless valid?
  # end
end
