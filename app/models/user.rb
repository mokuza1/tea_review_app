class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { general: 0, admin: 1 }

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
end
