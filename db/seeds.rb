# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "🌱 Seeding start..."

# =====================================
# Users（5件）
# =====================================
puts "Creating users..."

users = 5.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end

admin = users.first
puts "Users created: #{users.size}"

# =====================================
# Brands（8件）
# =====================================
puts "Creating brands..."

brand_names = [
  "伊藤園",
  "サントリー",
  "キリン",
  "AGF",
  "日東紅茶",
  "リプトン",
  "トワイニング",
  "紅茶専門店"
]

brands = brand_names.map.with_index do |name, i|
  status = i < 5 ? :published : :draft

  Brand.create!(
    name_ja: name,
    name_en: name,
    country: Faker::Address.country,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    user: users.sample,
    status: status,
    approved_by: status == :published ? admin : nil,
    approved_at: status == :published ? Faker::Time.backward(days: 60) : nil
  )
end

published_brands = brands.select(&:published?)

puts "Brands created: #{brands.size}"

# =====================================
# TeaProducts（20件）
# =====================================
puts "Creating tea products..."

# pending（承認待ち）5件
5.times do |n|
  TeaProduct.create!(
    name: "承認待ちのお茶 #{n + 1}",
    user: users.sample,
    brand: published_brands.sample,
    tea_type: TeaProduct.tea_types.keys.sample,
    caffeine_level: TeaProduct.caffeine_levels.keys.sample,
    description: Faker::Lorem.sentence,
    status: :pending
  )
end

# draft（下書き）5件
5.times do
  TeaProduct.create!(
    user: users.sample,
    status: :draft
    # brand / name / enum / description はあえて入れない
  )
end

# published（公開済み）10件
10.times do |n|
  TeaProduct.create!(
    name: "公開済みのお茶 #{n + 1}",
    user: users.sample,
    brand: published_brands.sample,
    tea_type: TeaProduct.tea_types.keys.sample,
    caffeine_level: TeaProduct.caffeine_levels.keys.sample,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    status: :published,
    approved_by: admin,
    approved_at: Faker::Time.backward(days: 30)
  )
end

puts "TeaProducts created: 20"

puts "✅ Seeding completed successfully!"
