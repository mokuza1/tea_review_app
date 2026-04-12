class Admin::TeaProductsController < Admin::BaseController
  def index
    @tea_products = TeaProduct
      .includes(:user)
      .order(created_at: :desc)
      .page(params[:page]).per(20)
  end

  def show
    @tea_product = TeaProduct.includes(
      :user,
      :brand,
      :purchase_locations,
      flavors: :flavor_category
    ).find(params[:id])
  end
end
