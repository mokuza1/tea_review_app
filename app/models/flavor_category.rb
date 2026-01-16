class FlavorCategory < ApplicationRecord
  has_many :flavors, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
