class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    # 共通の取得ロジックを使って全投稿を取得
    combined = fetch_all_posts

    # 最新の3件をトップに表示
    @recent_posts = combined.first(3)

    # お気に入り（ここは変更なし）
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
    @posts = fetch_all_posts
  end

  # お気に入り一覧ページ
  def favorites
    @favorite_tea_products =
      current_user.favorite_tea_products.includes(:image_attachment).order(created_at: :desc)
  end

  private

  # 投稿データをまとめて取得・ソートする共通メソッド
  def fetch_all_posts
    # 1. 申請中データ（ここでスコープを適用！）
    # .active.latest_only を呼び出すことで、重複や古い申請を除外します
    submissions =
      current_user
        .tea_product_submissions
        .active
        .latest_only
        .includes(:image_attachment)

    # 2. 公開済みの商品
    products =
      current_user
        .tea_products
        .includes(:image_attachment)

    # 配列として結合して日付順に並べる
    (submissions.to_a + products.to_a).sort_by(&:created_at).reverse
  end
end
