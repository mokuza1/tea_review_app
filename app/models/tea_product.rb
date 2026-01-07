class TeaProduct < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by
  belongs_to :brand
end
