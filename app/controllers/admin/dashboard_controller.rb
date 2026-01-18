class Admin::DashboardController < Admin::BaseController
  def index
    @pending_tea_products = TeaProduct.pending.count
    @pending_brands = Brand.pending.count
  end
end
