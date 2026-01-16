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

# =====================================
# FlavorCategories / Flavors
# =====================================
puts "Creating flavor categories & flavors..."

flavor_data = {
  "フルーツ系" => %w[アップル ピーチ ベリー レモン オレンジ],
  "フローラル系" => %w[ローズ ジャスミン ラベンダー],
  "スパイス系" => %w[シナモン ジンジャー カルダモン],
  "ナッツ・甘味系" => %w[バニラ キャラメル アーモンド],
  "その他" => %w[スモーキー ハーブ]
}

flavor_categories = flavor_data.map do |category_name, flavors|
  category = FlavorCategory.find_or_create_by!(name: category_name)

  flavors.each do |flavor_name|
    Flavor.find_or_create_by!(
      name: flavor_name,
      flavor_category: category
    )
  end

  category
end

puts "FlavorCategories created: #{FlavorCategory.count}"
puts "Flavors created: #{Flavor.count}"

# =====================================
# PurchaseLocations（enum 前提）
# =====================================
puts "Creating purchase locations..."

purchase_locations_data = [
  # スーパーマーケット
  { name: "イオン", location_type: :supermarket },
  { name: "西友", location_type: :supermarket },

  # コンビニ
  { name: "セブンイレブン", location_type: :convenience_store },
  { name: "ファミリーマート", location_type: :convenience_store },

  # 百貨店
  { name: "高島屋", location_type: :department_store },
  { name: "三越", location_type: :department_store },

  # 紅茶専門店
  { name: "ルピシア", location_type: :tea_specialty_store },
  { name: "マリアージュ フレール", location_type: :tea_specialty_store },

  # 専門店（カルディ・成城石井など）
  { name: "カルディ", location_type: :specialty_store },
  { name: "成城石井", location_type: :specialty_store },

  # ネット通販
  { name: "Amazon", location_type: :online_shop },
  { name: "楽天市場", location_type: :online_shop },

  # その他
  { name: "イベント限定販売", location_type: :other }
]

purchase_locations_data.each do |attrs|
  PurchaseLocation.find_or_create_by!(name: attrs[:name]) do |pl|
    pl.location_type = attrs[:location_type]
  end
end

puts "PurchaseLocations created: #{PurchaseLocation.count}"

# =====================================
# TeaProductFlavors
# =====================================
puts "Linking tea products with flavors..."

published_products = TeaProduct.where(status: :published)
all_flavors = Flavor.all

published_products.each do |product|
  # 2〜4個のフレーバーをランダム付与
  all_flavors.sample(rand(2..4)).each do |flavor|
    TeaProductFlavor.find_or_create_by!(
      tea_product: product,
      flavor: flavor
    )
  end
end

puts "TeaProductFlavors created: #{TeaProductFlavor.count}"

# =====================================
# TeaProductPurchaseLocations
# =====================================
puts "Linking tea products with purchase locations..."

all_locations = PurchaseLocation.all

published_products.each do |product|
  # 1〜3件の購入場所をランダム付与
  all_locations.sample(rand(1..3)).each do |location|
    TeaProductPurchaseLocation.find_or_create_by!(
      tea_product: product,
      purchase_location: location
    )
  end
end

puts "TeaProductPurchaseLocations created: #{TeaProductPurchaseLocation.count}"

puts "✅ Seeding completed successfully!"
