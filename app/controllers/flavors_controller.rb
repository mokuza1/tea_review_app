class FlavorsController < ApplicationController
  def index
    category = FlavorCategory.find(params[:flavor_category_id])

    flavors = category.flavors.order(:name)

    render json: flavors.map { |flavor|
      { id: flavor.id, name: flavor.name }
    }
  end
end
