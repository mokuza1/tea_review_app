class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_tea_product
  before_action :set_review, only: %i[edit update destroy]

  def index
    @reviews = @tea_product.reviews
                           .includes(:user)
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(10)
  end

  def new
    @review = current_user.reviews.find_or_initialize_by(
      tea_product: @tea_product
    )
  end

  def create
    @review = @tea_product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      flash[:notice] = "テイスティング記録を保存しました"
    
      # 成功時はTurbo.visitで詳細画面全体を再読み込みさせる
      render turbo_stream: turbo_stream.append(
        "review_modal", 
        "<script>Turbo.visit('#{tea_product_path(@tea_product)}')</script>".html_safe
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:notice] = "テイスティング記録を更新しました"
      redirect_to tea_product_path(@tea_product)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to tea_product_path(@tea_product), notice: "レビューを削除しました"
  end

  private

  def set_tea_product
    @tea_product = TeaProduct.find(params[:tea_product_id])
  end

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(
      :overall_rating,
      :aroma_rating,
      :bitterness_rating,
      :strength_rating,
      :sweetness_rating,
      :recommended_straight,
      :recommended_milk,
      :recommended_iced,
      :comment
    )
  end
end
