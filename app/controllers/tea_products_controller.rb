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
    @tea_product.status = :draft

    if @tea_product.save
      redirect_to edit_tea_product_path(@tea_product),
                  notice: "下書きを作成しました"
    else
      render :new
    end
  end

  def edit
    unless @tea_product.draft? || @tea_product.rejected?
      redirect_to tea_products_path, alert: "編集できない状態です"
    end
  end

  def update
    @tea_product = current_user.tea_products.find(params[:id])
    @tea_product.update_with_resubmission!(tea_product_params)

    redirect_to tea_products_path, notice: "商品を更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def submit
    @tea_product = current_user.tea_products.find(params[:id])
    @tea_product.submit!

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
      :tea_type,
      :caffeine_level,
      :description,
      flavor_ids: [],
      purchase_location_ids: []
    )
  end
end
