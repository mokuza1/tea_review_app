class TeaProductsController < ApplicationController
  def index
    @tea_products = TeaProduct.includes(:brand)
  end
end
