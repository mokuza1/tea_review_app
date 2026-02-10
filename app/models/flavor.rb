class Flavor < ApplicationRecord
  belongs_to :flavor_category

  has_many :tea_product_flavors, dependent: :destroy
  has_many :tea_products, through: :tea_product_flavors

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name flavor_category_id]
  end
end
