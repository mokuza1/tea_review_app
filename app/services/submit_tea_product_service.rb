class SubmitTeaProductService
  def initialize(tea_product)
    @tea_product = tea_product
    @brand = tea_product.brand
  end

  def call
    success = false

    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless submit_brand_if_needed
      raise ActiveRecord::Rollback unless @tea_product.submit

      success = true
    end

    success
  end

  private

  def submit_brand_if_needed
    return true if @brand.nil?
    return true unless @brand.draft?

    @brand.submit
  end
end
