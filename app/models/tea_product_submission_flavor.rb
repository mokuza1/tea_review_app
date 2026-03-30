class TeaProductSubmissionFlavor < ApplicationRecord
    belongs_to :tea_product_submission
    belongs_to :flavor

    validates :flavor_id, uniqueness: { scope: :tea_product_submission_id }
end
