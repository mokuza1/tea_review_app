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

  # 管理者による情報編集
  def update
    brand = Brand.find(params[:id])

    brand.update!(brand_params)

    redirect_to admin_brand_path(brand), notice: "ブランド情報を更新しました"
  rescue ActiveRecord::RecordInvalid
    @brand = brand
    flash.now[:alert] = "入力内容に誤りがあります"
    render :show
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

  private

  def brand_params
    params.require(:brand).permit(
      :name_ja,
      :name_en,
      :country,
      :description
    )
  end
end
