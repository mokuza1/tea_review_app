class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tea_product

  def create
    current_user.favorites.create!(tea_product: @tea_product)
    flash[:notice] = "お気に入りに追加しました"
    render_turbo_stream
  end

  def destroy
    favorite = current_user.favorites.find_by!(tea_product: @tea_product)
    favorite.destroy
    flash[:notice] = "お気に入りを解除しました"
    render_turbo_stream
  end

  private

  def set_tea_product
    @tea_product = TeaProduct.find(params[:tea_product_id])
  end

  def render_turbo_stream
    render turbo_stream: [
      turbo_stream.replace(
        "favorite_button_#{@tea_product.id}",
        partial: "favorites/button",
        locals: { tea_product: @tea_product }
      ),
      turbo_stream.update(
        "flash",
        partial: "shared/flash"
      )
    ]
  end
end
