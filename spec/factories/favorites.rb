FactoryBot.define do
  factory :favorite do
    association :user
    association :tea_product
  end
end
