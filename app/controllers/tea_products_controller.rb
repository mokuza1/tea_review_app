class TeaProductsController < ApplicationController
  def index
    @tea_products = TeaProduct.published.includes(:brand).order(created_at: :desc)
  end

  def show
    @tea_product = TeaProduct.published.includes(:brand).find(params[:id])
  end
end
