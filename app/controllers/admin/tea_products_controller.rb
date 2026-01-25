class Admin::TeaProductsController < Admin::BaseController
  def index
    @tea_products = TeaProduct
    .includes(:user, :brand)
    .order(created_at: :desc)

    @tea_products = @tea_products.where(status: params[:status]) if params[:status].present?
  end

  def show
    @tea_product = TeaProduct.find(params[:id])
  end

  def approve
    tea_product = TeaProduct.find(params[:id])
    tea_product.approve!(current_user)

    redirect_to admin_tea_products_path, notice: "承認しました"
  rescue InvalidStatusTransition
    redirect_to admin_tea_products_path, alert: "承認できない状態です"
  end

  def reject
    tea_product = TeaProduct.find(params[:id])
    tea_product.reject!(current_user)

    redirect_to admin_tea_products_path, notice: "却下しました"
  rescue InvalidStatusTransition
    redirect_to admin_tea_products_path, alert: "却下できない状態です"
  end
end
