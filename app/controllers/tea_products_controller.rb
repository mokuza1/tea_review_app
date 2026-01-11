class TeaProductsController < ApplicationController
  def index
    @tea_products = TeaProduct.published.includes(:brand).order(created_at: :desc)
  end
end
