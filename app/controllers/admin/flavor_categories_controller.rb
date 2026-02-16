class Admin::FlavorCategoriesController < Admin::BaseController
  def index
    @flavor_categories = FlavorCategory.order(:created_at)
  end

  def new
    @flavor_category = FlavorCategory.new
  end

  def create
    @flavor_category = FlavorCategory.new(flavor_category_params)
    if @flavor_category.save
      redirect_to admin_flavor_categories_path, notice: "大カテゴリを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @flavor_category = FlavorCategory.find(params[:id])
  end

  def update
    @flavor_category = FlavorCategory.find(params[:id])
    if @flavor_category.update(flavor_category_params)
      redirect_to admin_flavor_categories_path, notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def flavor_category_params
    params.require(:flavor_category).permit(:name)
  end
end
