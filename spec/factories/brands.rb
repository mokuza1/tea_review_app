# spec/factories/brands.rb
FactoryBot.define do
  factory :brand do
    # sequence を使うことで "Tea Type 1", "Tea Type 2" ... と絶対に重複しない値を作れます
    sequence(:name_ja) { |n| "#{Faker::Tea.type} #{n}ブランド" }
    sequence(:name_en) { |n| "Tea Brand #{n}" }

    country { "United Kingdom" }
    description { "美味しい紅茶のブランドです。" }
    status { :published }
    association :user
  end
end
