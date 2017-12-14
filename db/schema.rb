# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171213225219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "base_amounts", force: :cascade do |t|
    t.integer "amount"
    t.datetime "tareekh"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_base_amounts_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "size"
    t.integer "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "installments", force: :cascade do |t|
    t.integer "amount"
    t.datetime "target_date"
    t.bigint "plot_file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_file_id"], name: "index_installments_on_plot_file_id"
  end

  create_table "plot_files", force: :cascade do |t|
    t.text "serial_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "region_id"
    t.integer "state"
    t.index ["category_id"], name: "index_plot_files_on_category_id"
    t.index ["region_id"], name: "index_plot_files_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "unique_id"
    t.string "temporary_id"
    t.bigint "plot_file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_amount"
    t.float "recieved_amount"
    t.datetime "target_date"
    t.integer "status"
    t.bigint "user_id"
    t.index ["plot_file_id"], name: "index_transactions_on_plot_file_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "username"
    t.string "cnic"
    t.string "address"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "base_amounts", "categories"
  add_foreign_key "installments", "plot_files"
  add_foreign_key "plot_files", "categories"
  add_foreign_key "plot_files", "regions"
  add_foreign_key "transactions", "plot_files"
  add_foreign_key "transactions", "users"
end
