class Brand < ApplicationRecord
  class InvalidStatusTransition < StandardError; end
  belongs_to :user
  belongs_to :approved_by,
             class_name: "User",
             optional: true

  has_many :tea_products

  validates :name_ja, length: { maximum: 255 }, allow_blank: true
  validates :name_en, length: { maximum: 255 }, allow_blank: true
  validates :country, length: { maximum: 100 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  validate :name_ja_or_name_en_present

  before_destroy :prevent_destroy_if_published

  enum :status, {
    draft: 0,
    pending: 10,
    rejected: 15,
    published: 20
  }

  def display_name
    name_ja.presence || name_en
  end

  # ===========
  # 一般ユーザー側
  # ===========

  def update_with_resubmission!(params)
    transaction do
      update!(params)
      update!(status: :draft) if rejected?
    end
  end

  def submit!
    raise InvalidStatusTransition unless draft?

    update!(status: :pending)
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

  def name_ja_or_name_en_present
    if name_ja.blank? && name_en.blank?
      errors.add(:base, "ブランド名（日本語または英語）のいずれかを入力してください")
    end
  end

  def prevent_destroy_if_published
    if published?
      errors.add(:base, "承認済みブランドは削除できません")
      throw(:abort)
    end
  end
end
