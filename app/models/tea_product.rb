class TeaProduct < ApplicationRecord
  include PreventableDestroyIfPublished

  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :brand

  has_many :tea_product_flavors, dependent: :destroy
  has_many :flavors, through: :tea_product_flavors
  has_many :tea_product_purchase_locations, dependent: :destroy
  has_many :purchase_locations, through: :tea_product_purchase_locations
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :tea_product_submissions, dependent: :nullify

  has_one :tea_product_submission

  has_one_attached :image

  enum :status, {
    published: 20
  }

  enum :tea_type, {
    black: 0,
    green: 10,
    oolong: 20,
    white: 30,
    herbal: 40
  }

  enum :caffeine_level, {
    caffeinated: 0,
    non_caffeinated: 10,
    decaffeinated: 20
  }

  validates :name, presence: true, length: { maximum: 100 }
  validates :brand, presence: true
  validates :tea_type, presence: true
  validates :caffeine_level, presence: true

  scope :viewable_by, ->(user) { published }

  def status_i18n
    enum_i18n(:status)
  end

  # 検索可能カラム
  def self.ransackable_attributes(auth_object = nil)
    %w[name brand_id tea_type caffeine_level]
  end

  # 関連先で検索許可
  def self.ransackable_associations(auth_object = nil)
    %w[brand flavors]
  end

  def favorited_by?(user)
    return false unless user
    favorites.exists?(user: user)
  end
end
