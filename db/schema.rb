# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_20_155940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_ranges", force: :cascade do |t|
    t.integer "from"
    t.integer "to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "count_by_age_ranges", force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "age_range_id", null: false
    t.index ["age_range_id"], name: "index_count_by_age_ranges_on_age_range_id"
    t.index ["promotion_id", "age_range_id"], name: "index_count_by_age_ranges_on_promotion_id_and_age_range_id", unique: true
  end

  create_table "count_by_cities", force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "city_id", null: false
    t.index ["city_id"], name: "index_count_by_cities_on_city_id"
    t.index ["promotion_id"], name: "index_count_by_cities_on_promotion_id", unique: true
  end

  create_table "count_by_countries", force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_count_by_countries_on_country_id"
    t.index ["promotion_id"], name: "index_count_by_countries_on_promotion_id", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "promotion_organizations", force: :cascade do |t|
    t.integer "promotion_id"
    t.string "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["promotion_id"], name: "index_promotion_organizations_on_promotion_id", unique: true
  end

  create_table "usage_reports", force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "invocations_count", default: 0
    t.float "negative_responses_count", default: 0.0
    t.float "average_response_time", default: 0.0
    t.float "total_money_spent", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["promotion_id"], name: "index_usage_reports_on_promotion_id", unique: true
  end

  add_foreign_key "cities", "countries"
  add_foreign_key "count_by_age_ranges", "age_ranges"
  add_foreign_key "count_by_cities", "cities"
  add_foreign_key "count_by_countries", "countries"
end
