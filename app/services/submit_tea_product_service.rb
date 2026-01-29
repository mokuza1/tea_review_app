class SubmitTeaProductService
  def initialize(tea_product)
    @tea_product = tea_product
    @brand = tea_product.brand
  end

  def call!
    ActiveRecord::Base.transaction do
      submit_brand_if_needed!
      @tea_product.submit!
    end
  end

  private

  def submit_brand_if_needed!
    return if @brand.nil?
    return unless @brand.draft?

    @brand.submit!
  end
end
