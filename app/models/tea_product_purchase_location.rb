class TeaProductPurchaseLocation < ApplicationRecord
  belongs_to :tea_product
  belongs_to :purchase_location, optional: true

  validates :purchase_location, presence: true, unless: -> { tea_product&.draft? }

  accepts_nested_attributes_for :purchase_location,
                                reject_if: :all_blank
end
