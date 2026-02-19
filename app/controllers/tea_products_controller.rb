class TeaProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_tea_product, only: %i[edit update]
  before_action :prepare_edit_form, only: %i[edit update submit]

  def index
    base_scope = TeaProduct.where(status: :published)

    @q = base_scope.includes(:brand, :image_attachment).ransack(search_params)

    @tea_products = @q.result(distinct: true)
                      .order(created_at: :desc)
                      .page(params[:page])
    @brands = Brand.published.order(:name_ja)
    @flavor_categories = FlavorCategory.includes(:flavors)
  end

  def show
    @tea_product = TeaProduct
      .includes(:brand, :purchase_locations, flavors: :flavor_category)
      .find(params[:id])
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
  
    # 購入場所などはそのまま
    purchase_location_params = normalized.delete(:purchase_location)

    @tea_product = current_user.tea_products.build(normalized)
  
    # エラー時にフォームが空にならないよう、値を保持させる
    @tea_product.brand_id = brand_id
    @tea_product.brand_name = brand_name

    # 両方空の時だけチェックする（両方ある場合は brand_id を優先するロジックにする）
    if brand_id.blank? && brand_name.blank?
      flash.now[:alert] = "ブランドを選択するか、新しく入力してください"
      render :new, status: :unprocessable_entity and return
    end

    @tea_product.status = :draft

    ActiveRecord::Base.transaction do
      # --- ブランド紐付けロジック ---
      if brand_id.present?
        @tea_product.brand = Brand.find(brand_id)
      else
        # 手入力の場合：既存を探す。なければ新規作成(status: :draft)
        # ※DB側に name_ja のユニークインデックスが必須
        @tea_product.brand = Brand.create_or_find_by!(name_ja: brand_name) do |b|
          b.status = :draft
          b.user = current_user
        end
      end

      if purchase_location_params.present?
          save_purchase_location!(
            tea_product: @tea_product,
            params: purchase_location_params
          )
      end

      @tea_product.save!
    end

    redirect_to edit_tea_product_path(@tea_product),
                notice: "下書きを作成しました"
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "保存に失敗しました: #{e.record.errors.full_messages.join(', ')}"
    render :new, status: :unprocessable_entity
  end

  def edit
    unless @tea_product.draft? || @tea_product.rejected?
      redirect_to tea_products_path, alert: "編集できない状態です"
    end
  end

  def update
    @tea_product = current_user.tea_products.find(params[:id])

    # パラメータの整理
    normalized = tea_product_params.dup
    brand_id   = normalized.delete(:brand_id).presence
    brand_name = normalized.delete(:brand_name).to_s.strip
    purchase_location_params = normalized.delete(:purchase_location)

    # 画面再表示用に仮想属性・関連IDをセット
    @tea_product.brand_id = brand_id
    @tea_product.brand_name = brand_name

    # ブランド未入力チェック（新規でも既存でもない場合）
    if brand_id.blank? && brand_name.blank?
      flash.now[:alert] = "ブランドを選択するか、新しく入力してください"
      prepare_edit_form
      render :edit, status: :unprocessable_entity and return
    end

    ActiveRecord::Base.transaction do
      # --- ブランド紐付けロジック ---
      if brand_id.present?
        @tea_product.brand = Brand.find(brand_id)
      else
        # 手入力の場合：既存を探すか、新規(draft)で作成
        @tea_product.brand = Brand.create_or_find_by!(name_ja: brand_name) do |b|
          b.status = :draft
          b.user = current_user
        end
      end

      # ---- TeaProduct 本体更新 ----
      if @tea_product.rejected?
        @tea_product.update_with_resubmission!(normalized)
      else
        @tea_product.update!(normalized)
      end

      # ---- 購入場所更新 ----
      if purchase_location_params.present?
        save_purchase_location!(
          tea_product: @tea_product,
          params: purchase_location_params
        )
      end
    end

    if @tea_product.rejected?
      redirect_to mypage_path,
                  notice: "再申請用に下書きへ戻しました"
    else
      redirect_to edit_tea_product_path(@tea_product),
                  notice: "商品を更新しました"
    end
  rescue ActiveRecord::RecordInvalid => e
    prepare_edit_form
    flash.now[:alert] = "保存に失敗しました: #{e.record.errors.full_messages.join(', ')}"
    render :edit, status: :unprocessable_entity
  end

  def submit
    @tea_product = current_user.tea_products.find(params[:id])

    if SubmitTeaProductService.new(@tea_product).call
      redirect_to mypage_path,
                  notice: "申請しました（最後に保存した内容が申請されます）"
    else
      prepare_edit_form
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "商品が見つかりませんでした"
  end

  private

  def set_tea_product
    @tea_product = TeaProduct
      .viewable_by(current_user)
      .includes(:brand)
      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "商品が見つかりませんでした"
  end

  # 大カテゴリ再描画
  def prepare_edit_form
    return unless @tea_product

    @tea_product.selected_flavor_category_ids =
      params.dig(:tea_product, :selected_flavor_category_ids) ||
      @tea_product.flavors
                  .pluck(:flavor_category_id)
                  .uniq
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
      location = PurchaseLocation.find_or_create_by!(
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
      :image,
      { selected_flavor_category_ids: [] },
      { flavor_ids: [] },
      purchase_location: [
      :location_type,
      :name
      ]
    )
  end

  def search_params
    return {} unless params[:q]

    # URL引き継ぎ用（to_unsafe_h 前提）
    params[:q].to_unsafe_h.slice(
      "name_or_brand_name_ja_or_brand_name_en_cont",
      "brand_id_eq",
      "flavors_id_eq",
      "flavors_flavor_category_id_eq"
    )
  end
end
