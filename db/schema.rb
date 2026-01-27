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

ActiveRecord::Schema[7.2].define(version: 2026_01_27_142723) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "figures", force: :cascade do |t|
    t.string "name", null: false
    t.date "release_month", null: false
    t.integer "quantity", null: false
    t.integer "price", null: false
    t.integer "payment_status", null: false
    t.integer "size_type"
    t.integer "size_mm"
    t.text "note"
    t.bigint "user_id"
    t.bigint "manufacturer_id"
    t.bigint "work_id"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_price", default: 0, null: false
    t.index ["manufacturer_id"], name: "index_figures_on_manufacturer_id"
    t.index ["shop_id"], name: "index_figures_on_shop_id"
    t.index ["user_id"], name: "index_figures_on_user_id"
    t.index ["work_id"], name: "index_figures_on_work_id"
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "email_notification_timing", default: 4, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "figures", "manufacturers"
  add_foreign_key "figures", "shops"
  add_foreign_key "figures", "users"
  add_foreign_key "figures", "works"
end
