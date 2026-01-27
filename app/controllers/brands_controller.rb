class BrandsController < ApplicationController
  before_action :authenticate_user!

  def update
    @brand = current_user.brands.find(params[:id])
    @brand.update_with_resubmission!(brand_params)

    redirect_to brands_path,
      notice: "ブランドを更新しました。再申請する場合は「申請する」を押してください"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def submit
    @brand = current_user.brands.find(params[:id])
    @brand.submit!

    redirect_to brands_path, notice: "ブランドを申請しました"
  rescue Brand::InvalidStatusTransition
    redirect_to brands_path, alert: "申請できない状態です"
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
