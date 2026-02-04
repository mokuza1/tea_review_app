class SubmitTeaProductService
  def initialize(tea_product)
    @tea_product = tea_product
    @brand = tea_product.brand
  end

  def call
      ActiveRecord::Base.transaction do
        return false unless submit_brand_if_needed
        return false unless @tea_product.submit
      end

      true
    end

  private

  def submit_brand_if_needed
    return true if @brand.nil?
    return true unless @brand.draft?

    @brand.submit
  end
end
