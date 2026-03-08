class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @recent_tea_products =
      current_user
        .tea_products
        .includes(:image_attachment)
        .order(created_at: :desc)
        .limit(3)
    @recent_favorite_tea_products = 
      current_user
        .favorite_tea_products
        .includes(:image_attachment)
        .order(created_at: :desc)
        .limit(3)

    @tea_products_count = current_user.tea_products.count
    @favorites_count = current_user.favorite_tea_products.count
  end

  # 自分の投稿一覧ページ
  def my_tea_products
    @tea_products =
      current_user.tea_products.includes(:image_attachment).order(created_at: :desc)
  end

  # お気に入り一覧ページ
  def favorites
    @favorite_tea_products =
      current_user.favorite_tea_products.includes(:image_attachment).order(created_at: :desc)
  end
end
