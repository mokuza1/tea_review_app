FactoryBot.define do
  factory :flavor do
    name { "レモン" }
    association :flavor_category
  end
end
