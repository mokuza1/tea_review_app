FactoryBot.define do
  factory :tea_product_submission do
    sequence(:name) { |n| "申請中の紅茶 #{n}" }
    tea_type { :black }
    caffeine_level { :caffeinated }
    status { :draft }
    association :user
    association :brand

    # 申請(pending)にするためのトレイト
    trait :to_be_pending do
      status { :pending }
      # バリデーションを通すためにフレーバーと購入場所を追加
      after(:build) do |submission|
        submission.flavors << (Flavor.first || create(:flavor))
        submission.tea_product_submission_purchase_locations << build(:tea_product_submission_purchase_location, tea_product_submission: submission)
      end
    end
  end

  # 中間テーブルのファクトリも必要
  factory :tea_product_submission_purchase_location do
    association :purchase_location
  end
end
