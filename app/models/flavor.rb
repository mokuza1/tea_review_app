class Flavor < ApplicationRecord
  belongs_to :flavor_category

  has_many :product_flavors, dependent: :destroy
  has_many :tea_products, through: :product_flavors

  validates :name, presence: true
end
