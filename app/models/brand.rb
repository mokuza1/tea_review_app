class Brand < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by
end
