class TeaProductPurchaseLocation < ApplicationRecord
  belongs_to :tea_product
  belongs_to :purchase_location

  accepts_nested_attributes_for :purchase_location,
                                reject_if: :all_blank
end
