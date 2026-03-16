class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tea_product

  validates :overall_rating, presence: true, inclusion: { in: 1..5 }
  validates :aroma_rating, presence: true, inclusion: { in: 1..5 }
  validates :bitterness_rating, presence: true, inclusion: { in: 1..5 }
  validates :strength_rating, presence: true, inclusion: { in: 1..5 }
  validates :sweetness_rating, presence: true, inclusion: { in: 1..5 }

  validates :comment, length: { maximum: 140 }

  validates :user_id,
    uniqueness: {
      scope: :tea_product_id,
      message: "この紅茶にはすでにレビューしています"
    }
end
