# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# =====================================
# 1. 共通設定: Adminユーザーの作成 (本番・開発両方)
# =====================================
# RenderのEnvironment Variablesで設定した値、またはローカルのENVを使用
admin_email = ENV["ADMIN_EMAIL"]
admin_password = ENV["ADMIN_PASSWORD"]

if admin_email.present? && admin_password.present?
  admin = User.find_or_create_by!(email: admin_email) do |user|
    user.name = "Admin User" # 名前が必要な場合は適宜変更
    user.password = admin_password
    user.password_confirmation = admin_password
    user.role = :admin
  end
  puts "✅ Admin user created/found: #{admin.email}"
else
  puts "⚠️ Admin user creation skipped: ADMIN_EMAIL or ADMIN_PASSWORD not set."
end

# =====================================
# 2. 開発環境限定のテストデータ (Rails.env.development? の中に入れる)
# =====================================
if Rails.env.development?
  puts "🧪 Creating dummy data for development..."

  admin ||= User.find_by(role: :admin) || User.first

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
  admin.update!(role: :admin)
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

    Brand.find_or_create_by!(name_ja: name) do |b|
      b.name_en = name
      b.country = Faker::Address.country
      b.description = Faker::Lorem.paragraph(sentence_count: 2)
      b.user = users.sample
      b.status = status
      b.approved_by = status == :published ? admin : nil
      b.approved_at = status == :published ? Faker::Time.backward(days: 60) : nil
    end
  end

  published_brands = Brand.where(name_ja: brand_names.first(5))

  puts "Brands created: #{brands.size}"

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
  # TeaProducts（20件）
  # =====================================
  puts "Creating tea products..."

  all_flavors = Flavor.all
  all_locations = PurchaseLocation.all

  # pending（承認待ち）5件
  5.times do |n|
    submission = TeaProductSubmission.new(
      name: "承認待ちのお茶 #{n + 1}",
      user: users.sample,
      brand: published_brands.sample,
      tea_type: TeaProductSubmission.tea_types.keys.sample,
      caffeine_level: TeaProductSubmission.caffeine_levels.keys.sample,
      description: Faker::Lorem.sentence,
      status: :pending
    )

    # フレーバー1〜3個
    submission.flavors << all_flavors.sample(rand(1..3))

    # 購入場所は1件のみ（バリデーションに合わせる）
    submission.purchase_locations << all_locations.sample

    submission.save!
  end

  # draft（下書き）5件
  5.times do
    TeaProductSubmission.create!(
      user: users.sample,
      status: :draft
    )
  end

  # published（公開済み）10件
  10.times do |n|
    product = TeaProduct.new(
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

    product.flavors << all_flavors.sample(rand(1..3))
    product.purchase_locations << all_locations.sample

    product.save!
  end

  puts "TeaProducts created: #{TeaProduct.count}"
  puts "TeaProductSubmissions created: #{TeaProductSubmission.count}"

end

puts "✅ Seeding completed successfully!"
