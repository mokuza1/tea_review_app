FactoryBot.define do
  factory :purchase_location do
    sequence(:name) { |n| "お茶専門店 #{n}" }
    location_type { :tea_specialty_store }
  end
end
