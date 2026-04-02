class TeaProductPurchaseLocation < ApplicationRecord
  belongs_to :tea_product
  belongs_to :purchase_location
end
