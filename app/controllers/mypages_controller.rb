class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @tea_products =
      current_user
        .tea_products
        .includes(:image_attachment)
        .order(created_at: :desc)
  end
end
