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
    normalized = tea_product_params.dup

    brand_id   = normalized.delete(:brand_id).presence
    brand_name = normalized.delete(:brand_name).to_s.strip
    purchase_location_params = normalized.delete(:purchase_location)

    @tea_product = current_user.tea_products.build(normalized)

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

        if purchase_location_params.present?
          save_purchase_location!(
            tea_product: @tea_product,
            params: purchase_location_params
          )
        end
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
    @tea_product = current_user.tea_products
      .includes(
        :flavors,
        purchase_locations: []
      )
      .find(params[:id])

    @tea_product.selected_flavor_category_id ||=
      @tea_product.flavors.first&.flavor_category_id

    unless @tea_product.draft? || @tea_product.rejected?
      redirect_to tea_products_path, alert: "編集できない状態です"
    end
  end

  def update
    @tea_product = current_user.tea_products.find(params[:id])

    normalized = tea_product_params.dup

    brand_id   = normalized.delete(:brand_id).presence
    brand_name = normalized.delete(:brand_name).to_s.strip
    purchase_location_params = normalized.delete(:purchase_location)

    ActiveRecord::Base.transaction do
      current_brand = @tea_product.brand
      if brand_id.present?
        @tea_product.brand = Brand.find(brand_id)

      elsif brand_name.present?
        if current_brand&.display_name == brand_name
            # 変更なし → 何もしない(修正可能性あり)
        else
          brand = Brand.create!(
            name_ja: brand_name,
            status: :draft,
            user: current_user
          )
          @tea_product.brand = brand
        end
      end

      # ---- TeaProduct 本体更新 ----
      @tea_product.update_with_resubmission!(normalized)

      # ---- 購入場所更新 ----
      if purchase_location_params.present?
        save_purchase_location!(
          tea_product: @tea_product,
          params: purchase_location_params
        )
      end
    end

    redirect_to edit_tea_product_path(@tea_product),
                notice: "商品を更新しました"
  rescue ActiveRecord::RecordInvalid
      # 再描画用（フレーバー大カテゴリ保持）
    @tea_product.selected_flavor_category_id =
      params.dig(:tea_product, :selected_flavor_category_id)
    render :edit, status: :unprocessable_entity
  end

  def submit
    @tea_product = current_user.tea_products.find(params[:id])

    if SubmitTeaProductService.new(@tea_product).call
      redirect_to tea_products_path,
                  notice: "申請しました（最後に保存した内容が申請されます）"
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "商品が見つかりませんでした"
  end

  private

  def set_tea_product
    @tea_product = TeaProduct
      .viewable_by(current_user)
      .includes(:brand, :purchase_locations, :flavors)
      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "商品が見つかりませんでした"
  end

  def save_purchase_location!(tea_product:, params:)
    location_type = params[:location_type]
    name          = params[:name].to_s.strip

    # 両方必須（DB設計と完全一致）
    return if location_type.blank? || name.blank?

    # 既存の購入場所（1件前提）
    existing = tea_product.purchase_locations.first

    if existing
      existing.update!(
        location_type: location_type,
        name: name
      )
    else
      location = PurchaseLocation.create!(
        location_type: location_type,
        name: name
      )

      TeaProductPurchaseLocation.create!(
        tea_product: tea_product,
        purchase_location: location
      )
    end
  end

  def tea_product_params
    params.require(:tea_product).permit(
      :name,
      :brand_id,
      :brand_name,
      :tea_type,
      :caffeine_level,
      :description,
      :selected_flavor_category_id,
      flavor_ids: [],
      purchase_location: [
      :location_type,
      :name
      ]
    )
  end
end
