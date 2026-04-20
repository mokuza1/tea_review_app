class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    # 全投稿を取得
    combined = fetch_all_posts

    # 最新の3件
    @recent_posts = combined.first(3)

    @recent_favorite_tea_products =
      current_user
        .favorite_tea_products
        .includes(:image_attachment)
        .order(created_at: :desc)
        .limit(3)

    @recent_reviews =
        current_user
        .reviews
        .includes(tea_product: { image_attachment: :blob })
        .order(created_at: :desc)
        .limit(3)

    @posts_count = combined.size
    @favorites_count = current_user.favorite_tea_products.count
    @reviews_count = current_user.reviews.count
  end

  def my_tea_products
    all_posts = fetch_all_posts

    @posts = Kaminari.paginate_array(all_posts)
                     .page(params[:page])
                     .per(10)
  end

  def favorites
    @favorite_tea_products =
      current_user.favorite_tea_products.includes(:image_attachment)
                                        .order(created_at: :desc)
                                        .page(params[:page])
                                        .per(10)
  end

  def my_reviews
    @reviews =
      current_user.reviews.includes(tea_product: { image_attachment: :blob })
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(10)
  end

  private

  # 投稿データをまとめて取得・ソート
  def fetch_all_posts
    submissions =
      current_user
        .tea_product_submissions
        .active
        .latest_only
        .includes(:image_attachment)

    products =
      current_user
        .tea_products
        .includes(:image_attachment)

    (submissions.to_a + products.to_a).sort_by(&:created_at).reverse
  end
end
