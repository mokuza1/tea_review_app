class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :tea_product

  # 1人のユーザーは1つの投稿に対して1つしかお気に入りできない
  validates :user_id, uniqueness: { scope: :tea_product_id }
end
