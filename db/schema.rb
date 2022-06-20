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

ActiveRecord::Schema[7.0].define(version: 2022_06_20_152729) do
  create_table "book_details", force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "isbn"
    t.float "purchase_price"
    t.boolean "is_hot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_book_details_on_item_id"
  end

  create_table "downloads", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_downloads_on_item_id"
    t.index ["user_id"], name: "index_downloads_on_user_id"
  end

  create_table "image_details", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "width"
    t.integer "height"
    t.string "source"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_image_details_on_item_id"
  end

  create_table "image_external_details", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_image_external_details_on_item_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "item_id", null: false
    t.string "title"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_invoices_on_item_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "kind"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "video_details", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "duration"
    t.string "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_video_details_on_item_id"
  end

  add_foreign_key "book_details", "items"
  add_foreign_key "downloads", "items"
  add_foreign_key "downloads", "users"
  add_foreign_key "image_details", "items"
  add_foreign_key "image_external_details", "items"
  add_foreign_key "invoices", "items"
  add_foreign_key "invoices", "users"
  add_foreign_key "video_details", "items"
end
