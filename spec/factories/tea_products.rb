FactoryBot.define do
  factory :tea_product do
    sequence(:name) { |n| "#{Faker::Tea.variety} #{n}" }
    description { "最高級の茶葉を使用した紅茶です。" }
    tea_type { :black }
    caffeine_level { :caffeinated }
    status { :published }

    association :user
    association :brand
  end
end
