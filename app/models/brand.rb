class Brand < ApplicationRecord
  class InvalidStatusTransition < StandardError; end

  before_validation :normalize_name_ja

  include PreventableDestroyIfPublished

  belongs_to :user
  belongs_to :approved_by,
             class_name: "User",
             optional: true

  has_many :tea_products

  validates :name_ja, length: { maximum: 255 }, allow_blank: true, presence: true
  validates :name_en, length: { maximum: 255 }, allow_blank: true
  validates :country, length: { maximum: 100 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  # validate :name_ja_or_name_en_present

  enum :status, {
    draft: 0,
    pending: 10,
    rejected: 15,
    published: 20
  }

  scope :published, -> { where(status: :published) }

  def display_name
    name_ja.presence || name_en
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name_ja name_en]
  end

  # ===========
  # 一般ユーザー側
  # ===========

  def update_with_resubmission!(params)
    was_rejected = rejected?

    transaction do
      update!(params)
      update!(status: :draft) if was_rejected
    end
  end

  def submit
    return false unless draft?

    self.status = :pending
    valid? && save
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

  # def name_ja_or_name_en_present
  # if name_ja.blank? && name_en.blank?
  # errors.add(:base, "ブランド名（日本語または英語）のいずれかを入力してください")
  # end
  # end

  def normalize_name_ja
    return if name_ja.blank?

    self.name_ja = name_ja.strip
                         .tr("ぁ-ん", "ァ-ン")
                         .unicode_normalize(:nfkc)
                         .upcase
  end
end
