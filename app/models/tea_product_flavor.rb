class TeaProductFlavor < ApplicationRecord
  belongs_to :tea_product
  belongs_to :flavor
end
