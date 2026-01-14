class PurchaseLocation < ApplicationRecord
  has_many :tea_product_purchase_locations, dependent: :destroy
  has_many :tea_products, through: :tea_product_purchase_locations

  enum :location_type, {
    supermarket: 0,          # スーパーマーケット
    convenience_store: 10,    # コンビニエンスストア
    department_store: 20,     # 百貨店（高島屋、三越）
    tea_specialty_store: 30,  # 紅茶専門店
    specialty_store: 40,      # 専門店（カルディ、成城石井）
    online_shop: 50,          # ネット通販
    other: 60                 # その他
  }

  validates :name, presence: true, uniqueness: true
  validates :location_type, presence: true
end
