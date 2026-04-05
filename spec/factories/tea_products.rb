# spec/factories/tea_products.rb
FactoryBot.define do
  factory :tea_product do
    sequence(:name) { |n| "#{Faker::Tea.variety} #{n}" }
    description { "最高級の茶葉を使用した紅茶です。" }
    tea_type { :black }
    caffeine_level { :caffeinated }
    status { :published }

    association :user
    association :brand

    # 画像を添付した状態のデータを作りたい場合
    # trait :with_image do
      #after(:build) do |tea_product|
        #tea_product.image.attach(
          #io: File.open(Rails.root.join('spec/fixtures/files/test_image.png')),
          #filename: 'test_image.png',
          #content_type: 'image/png'
        #)
      #end
    #end
  end
end
