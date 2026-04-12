FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    role { :general }

    trait :admin do
      role { :admin }
    end
  end
end
