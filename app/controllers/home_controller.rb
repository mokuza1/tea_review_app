class HomeController < ApplicationController
  def index
    @q = TeaProduct.where(status: :published).ransack(params[:q])
    @brands = Brand.published.order(:name_ja)
    @flavor_categories = FlavorCategory.includes(:flavors)
  end
end
