class TeaProduct < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :brand, optional: true

  has_many :tea_product_flavors, dependent: :destroy
  has_many :flavors, through: :tea_product_flavors
  has_many :tea_product_purchase_locations, dependent: :destroy
  has_many :purchase_locations, through: :tea_product_purchase_locations

  enum :status, {
    draft: 0,
    pending: 10,
    published: 20
  }

  enum :tea_type, {
    leaf: 0,
    tea_bag: 10,
    powder: 20,
    liquid: 30,
    bottle: 40
  }

  enum :caffeine_level, {
    caffeinated: 0,
    non_caffeinated: 10,
    decaffeinated: 20
  }

  validates :name, presence: true, unless: :draft?
  validates :brand, presence: true, unless: :draft?
  validates :tea_type, presence: true, unless: :draft?
  validates :caffeine_level, presence: true, unless: :draft?

  # コールバック
  before_save :set_approved_at, if: :will_be_published?

  private

  def set_approved_at
    self.approved_at = Time.current
  end

  def will_be_published?
    # statusがpublishedに変更される時だけtrueを返す
    status_changed? && published?
  end
end
