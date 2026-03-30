class TeaProductFlavor < ApplicationRecord
  belongs_to :tea_product
  belongs_to :flavor

  validates :flavor_id, uniqueness: { scope: :tea_product_id }
end
