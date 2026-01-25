class Brand < ApplicationRecord
  class InvalidStatusTransition < StandardError; end
  belongs_to :user
  belongs_to :approved_by,
             class_name: "User",
             optional: true

  enum :status, {
    draft: 0,
    pending: 10,
    rejected: 15,
    published: 20
  }

  validate :name_ja_or_name_en_present

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

  def display_name
    name_ja.presence || name_en
  end

  private

  def name_ja_or_name_en_present
    if name_ja.blank? && name_en.blank?
      errors.add(:base, "ブランド名（日本語または英語）のいずれかを入力してください")
    end
  end
end
