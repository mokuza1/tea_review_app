class TeaProductsController < ApplicationController
  before_action :set_tea_product, only: %i[show]

  def index
    base_scope = TeaProduct.where(status: :published)
    @q = base_scope.includes(:brand, :image_attachment).ransack(search_params)
    @tea_products = @q.result(distinct: true)
                      .order(created_at: :desc)
                      .page(params[:page])
    @brands = Brand.published.order(:name_ja)
    @flavor_categories = FlavorCategory.includes(:flavors)
  end

  def show
    @tea_product = TeaProduct
      .viewable_by(current_user)
      .includes(:brand, tea_product_purchase_locations: :purchase_location, flavors: :flavor_category)
      .find(params[:id])

    @submission = @tea_product.tea_product_submission

    reviews = @tea_product.reviews

    @reviews = reviews
                  .includes(:user)
                  .order(created_at: :desc)
                  .limit(3)

    @review_summary = ReviewSummaryService.call(reviews)

    @user_review = current_user&.reviews&.find_by(tea_product: @tea_product)
  end

  private

  def set_tea_product
    @tea_product = current_user.tea_products
                               .includes(:brand)
                               .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "商品が見つかりませんでした"
  end


  def search_params
    return {} unless params[:q]

    # URL引き継ぎ用（to_unsafe_h 前提）
    params[:q].to_unsafe_h.slice(
      "name_or_brand_name_ja_or_brand_name_en_cont",
      "brand_id_eq",
      "flavors_id_eq",
      "flavors_flavor_category_id_eq",
      "tea_type_eq",
      "caffeine_level_eq"
    )
  end
end
