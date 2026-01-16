class TeaProductsController < ApplicationController
  before_action :set_tea_product, only: :show

  def index
    @tea_products = TeaProduct
      .published
      .includes(:brand)
      .order(created_at: :desc)
  end

  def show
  end

  private

  def set_tea_product
    @tea_product = TeaProduct
      .viewable_by(current_user)
      .includes(:brand, :purchase_locations, flavors: :flavor_category)
      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: '商品が見つかりませんでした'
  end
end
