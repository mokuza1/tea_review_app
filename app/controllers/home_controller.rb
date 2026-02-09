class HomeController < ApplicationController
  def index
    @q = TeaProduct.where(status: :published).ransack(params[:q])
  end
end
