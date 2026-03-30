class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    submissions =
      current_user
        .tea_product_submissions
        .includes(:image_attachment)

    products =
      current_user
        .tea_products
        .includes(:image_attachment)

    combined =
      (submissions.to_a + products.to_a)
        .sort_by(&:created_at)
        .reverse

    @recent_posts = combined.first(3)

    @recent_favorite_tea_products =
      current_user
        .favorite_tea_products
        .includes(:image_attachment)
        .order(created_at: :desc)
        .limit(3)

    @posts_count = combined.size
    @favorites_count = current_user.favorite_tea_products.count
  end

  # 自分の投稿一覧ページ
  def my_tea_products
    submissions =
      current_user
        .tea_product_submissions
        .includes(:image_attachment)

    products =
      current_user
        .tea_products
        .includes(:image_attachment)

  # 配列として結合して日付順に並べる
    @posts =
      (submissions.to_a + products.to_a)
        .sort_by(&:created_at)
        .reverse
  end

  # お気に入り一覧ページ
  def favorites
    @favorite_tea_products =
      current_user.favorite_tea_products.includes(:image_attachment).order(created_at: :desc)
  end
end
