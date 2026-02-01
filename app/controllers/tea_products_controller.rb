class TeaProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tea_product, only: %i[show edit]

  def index
    @tea_products = TeaProduct
      .published
      .includes(:brand)
      .order(created_at: :desc)
      .page(params[:page])
  end

  def show
  end

  def new
    @tea_product = current_user.tea_products.build(
      status: :draft
    )
  end

  def create
    @tea_product = current_user.tea_products.build(tea_product_params)

    brand_id = @tea_product.brand_id.presence
    brand_name = tea_product_params[:brand_name].to_s.strip

    # ==================================
    # brand_id / brand_name 排他チェック
    # ==================================
    if brand_id.blank? && brand_name.blank?
      flash.now[:alert] = "ブランドを選択するか、新しく入力してください"
      render :new, status: :unprocessable_entity and return
    end

    if brand_id.present? && brand_name.present?
      flash.now[:alert] = "既存ブランドを選ぶか、新規ブランド入力のどちらかにしてください"
      render :new, status: :unprocessable_entity and return
    end

    @tea_product.status = :draft

    ActiveRecord::Base.transaction do
      if brand_id.present?
        # 既存ブランドを使用（何もしない）
      else
        # ==================================
        # 新規ブランドを同時作成（draft）
        # ==================================
        brand = Brand.create!(
          name_ja: brand_name,
          status: :draft,
          user: current_user
        )

        @tea_product.brand = brand
      end

      @tea_product.save!
    end

    redirect_to edit_tea_product_path(@tea_product),
                notice: "下書きを作成しました"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "保存に失敗しました"
    render :new, status: :unprocessable_entity
  end

  def edit
    unless @tea_product.draft? || @tea_product.rejected?
      redirect_to tea_products_path, alert: "編集できない状態です"
    end
  end

  def update
    @tea_product = current_user.tea_products.find(params[:id])

    normalized = tea_product_params.dup

    brand_id   = normalized.delete(:brand_id).presence
    brand_name = normalized.delete(:brand_name).to_s.strip

    ActiveRecord::Base.transaction do
      current_brand = @tea_product.brand
      if brand_id.present?
        @tea_product.brand = Brand.find(brand_id)

      elsif brand_name.present?
        if current_brand&.display_name == brand_name
            # 変更なし → 何もしない(修正可能性)
        else
          brand = Brand.create!(
            name_ja: brand_name,
            status: :draft,
            user: current_user
          )
          @tea_product.brand = brand
        end
      end

      @tea_product.update_with_resubmission!(normalized)
    end

   redirect_to edit_tea_product_path(@tea_product),
                notice: "商品を更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def submit
    tea_product = current_user.tea_products.find(params[:id])

    SubmitTeaProductService.new(tea_product).call!

    redirect_to tea_products_path, notice: "申請しました"
  rescue InvalidStatusTransition
    redirect_to tea_products_path, alert: "申請できない状態です"
  end

  private

  def set_tea_product
    @tea_product = TeaProduct
      .viewable_by(current_user)
      .includes(:brand, :purchase_locations, flavors: :flavor_category)
      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "商品が見つかりませんでした"
  end

  def tea_product_params
    params.require(:tea_product).permit(
      :name,
      :brand_id,
      :brand_name,
      :tea_type,
      :caffeine_level,
      :description,
      flavor_ids: [],
      #purchase_location_ids: []
    )
  end
end
