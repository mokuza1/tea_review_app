class Brand < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by,
             class_name: "User",
             optional: true

  enum :status, {
    draft: 0,
    pending: 1,
    published: 2
  }

  validate :name_ja_or_name_en_present

  private

  def name_ja_or_name_en_present
    if name_ja.blank? && name_en.blank?
      errors.add(:base, "ブランド名（日本語または英語）のいずれかを入力してください")
    end
  end
end
