class Admin::FlavorsController < Admin::BaseController
  before_action :set_flavor, only: %i[edit update]

  def index
    @flavor_category = FlavorCategory.find(params[:flavor_category_id])
    @flavors = @flavor_category.flavors.order(:name)
  end

  def new
    @flavor_category = FlavorCategory.find(params[:flavor_category_id])
    @flavor = @flavor_category.flavors.build
  end

  def create
    @flavor_category = FlavorCategory.find(params[:flavor_category_id])
    @flavor = @flavor_category.flavors.build(flavor_params)

    if @flavor.save
      redirect_to admin_flavor_category_flavors_path(@flavor_category)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @flavor.update(flavor_params)
      redirect_to admin_flavor_category_flavors_path(@flavor.flavor_category)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_flavor
    @flavor = Flavor.find(params[:id])
  end

  def flavor_params
    params.require(:flavor).permit(:name)
  end
end
