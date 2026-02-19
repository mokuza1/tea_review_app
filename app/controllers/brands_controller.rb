class BrandsController < ApplicationController
  before_action :authenticate_user!

  def update
    @brand = current_user.brands.find(params[:id])
    @brand.update_with_resubmission!(brand_params)

    redirect_to brands_path,
      notice: "ブランドを更新しました。再申請する場合は「申請する」を押してください"
  rescue ActiveRecord::RecordNotFound
    redirect_to brands_path, alert: "ブランドが見つかりませんでした"
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def submit
    @brand = current_user.brands.find(params[:id])
    @brand.submit

    redirect_to brands_path, notice: "ブランドを申請しました"
  rescue ActiveRecord::RecordNotFound
    redirect_to brands_path, alert: "ブランドが見つかりませんでした"
  rescue Brand::InvalidStatusTransition
    redirect_to brands_path, alert: "申請できない状態です"
  end

  def search
    q = params[:q].to_s.strip
                  .tr("ぁ-ん", "ァ-ン")  # ひらがな→カタカナ
                  .unicode_normalize(:nfkc)

    return render json: [] if q.blank?

    brands = Brand.published
                  .where(
                    "name_ja ILIKE :q OR name_en ILIKE :q",
                    q: "%#{q}%"
                  )
                  .order(Arel.sql("COALESCE(name_ja, name_en) ASC"))
                  .limit(10)

    render json: brands.map { |brand|
      {
        id: brand.id,
        name: brand.name_en.present? ? "#{brand.name_ja} (#{brand.name_en})" : brand.name_ja,
        name_ja: brand.name_ja
      }
    }
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
