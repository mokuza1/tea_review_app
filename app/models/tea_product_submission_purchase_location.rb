class TeaProductSubmissionPurchaseLocation < ApplicationRecord
    belongs_to :tea_product_submission
    belongs_to :purchase_location, optional: true

    accepts_nested_attributes_for :purchase_location, reject_if: :all_blank

    validates :purchase_location, presence: true, unless: -> { tea_product_submission&.draft? }
end
