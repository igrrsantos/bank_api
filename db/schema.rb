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

ActiveRecord::Schema[7.1].define(version: 2025_06_04_145427) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "bank_number", null: false
    t.string "bank_agency_number", null: false
    t.decimal "balance", precision: 15, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_number"], name: "index_bank_accounts_on_bank_number", unique: true
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "origin_account_id", null: false
    t.bigint "destination_account_id", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "description"
    t.datetime "transaction_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_account_id"], name: "index_transactions_on_destination_account_id"
    t.index ["origin_account_id"], name: "index_transactions_on_origin_account_id"
    t.index ["transaction_date"], name: "index_transactions_on_transaction_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "cpf", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bank_accounts", "users"
  add_foreign_key "transactions", "bank_accounts", column: "destination_account_id"
  add_foreign_key "transactions", "bank_accounts", column: "origin_account_id"
end
