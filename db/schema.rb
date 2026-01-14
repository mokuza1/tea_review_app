# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_14_122841) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brands", force: :cascade do |t|
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.string "country"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name_en"
    t.string "name_ja"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["approved_by_id"], name: "index_brands_on_approved_by_id"
    t.index ["user_id"], name: "index_brands_on_user_id"
  end

  create_table "flavor_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_flavor_categories_on_name", unique: true
  end

  create_table "flavors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "flavor_category_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["flavor_category_id", "name"], name: "index_flavors_on_flavor_category_id_and_name", unique: true
    t.index ["flavor_category_id"], name: "index_flavors_on_flavor_category_id"
  end

  create_table "purchase_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "location_type", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["location_type"], name: "index_purchase_locations_on_location_type"
    t.index ["name"], name: "index_purchase_locations_on_name", unique: true
  end

  create_table "tea_product_flavors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "flavor_id", null: false
    t.bigint "tea_product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["flavor_id"], name: "index_tea_product_flavors_on_flavor_id"
    t.index ["tea_product_id", "flavor_id"], name: "index_tea_product_flavors_on_tea_product_id_and_flavor_id", unique: true
    t.index ["tea_product_id"], name: "index_tea_product_flavors_on_tea_product_id"
  end

  create_table "tea_products", force: :cascade do |t|
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.bigint "brand_id"
    t.integer "caffeine_level"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "status", default: 0, null: false
    t.integer "tea_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["approved_by_id"], name: "index_tea_products_on_approved_by_id"
    t.index ["brand_id"], name: "index_tea_products_on_brand_id"
    t.index ["user_id"], name: "index_tea_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "brands", "users"
  add_foreign_key "brands", "users", column: "approved_by_id"
  add_foreign_key "flavors", "flavor_categories"
  add_foreign_key "tea_product_flavors", "flavors"
  add_foreign_key "tea_product_flavors", "tea_products"
  add_foreign_key "tea_products", "brands"
  add_foreign_key "tea_products", "users"
  add_foreign_key "tea_products", "users", column: "approved_by_id"
end
