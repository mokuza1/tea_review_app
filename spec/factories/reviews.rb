FactoryBot.define do
  factory :review do
    association :user
    association :tea_product
    
    overall_rating { rand(1..5) }
    aroma_rating { rand(1..5) }
    bitterness_rating { rand(1..5) }
    strength_rating { rand(1..5) }
    sweetness_rating { rand(1..5) }
    
    comment { "とても香りが良くて美味しい紅茶でした。" }
  end
end
