class Admin::DashboardController < Admin::BaseController
  def index
    @pending_submissions_count = TeaProductSubmission.pending.count
    @pending_brands_count = Brand.pending.count
    @published_tea_products_count = TeaProduct.published.count
    @users_count = User.count
  end
end
