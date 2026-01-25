class Admin::BrandsController < Admin::BaseController
  def index
    @brands = Brand
      .includes(:user)
      .order(created_at: :desc)

    @brands = @brands.where(status: params[:status]) if params[:status].present?
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def approve
    brand = Brand.find(params[:id])
    brand.approve!(current_user)

    redirect_to admin_brands_path, notice: "ブランドを承認しました"
  rescue InvalidStatusTransition
    redirect_to admin_brands_path, alert: "承認できない状態です"
  end

  def reject
    brand = Brand.find(params[:id])
    brand.reject!(current_user)

    redirect_to admin_brands_path, notice: "ブランドを却下しました"
  rescue InvalidStatusTransition
    redirect_to admin_brands_path, alert: "却下できない状態です"
  end
end
