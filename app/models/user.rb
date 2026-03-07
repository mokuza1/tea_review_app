class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { general: 0, admin: 1 }

  has_many :favorites, dependent: :destroy
  # ユーザーがお気に入りした紅茶の一覧を簡単に取得できるようにする
  has_many :favorite_tea_products, through: :favorites, source: :tea_product

  # 投稿者として
  has_many :brands
  has_many :tea_products

  # 承認者として
  has_many :approved_brands,
           class_name: "Brand",
           foreign_key: :approved_by_id

  has_many :approved_tea_products,
           class_name: "TeaProduct",
           foreign_key: :approved_by_id

  # お気に入り登録済みかどうかを判定するメソッド
  def favorited?(tea_product)
    favorites.exists?(tea_product_id: tea_product.id)
  end
end
