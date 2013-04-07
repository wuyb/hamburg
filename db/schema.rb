# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130407043021) do

  create_table "accounts", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.float    "balance"
    t.float    "interest_rate"
    t.float    "max_credit"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.integer  "currency_id"
  end

  create_table "bank_products", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "type_code"
    t.string   "area"
    t.string   "currency"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "expiration_date"
    t.string   "status"
    t.float    "net_value"
    t.string   "term"
    t.string   "style"
    t.float    "init_investment"
    t.float    "incr_investment"
    t.string   "risk"
    t.date     "fin_date"
    t.boolean  "can_buy"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "bank_id"
    t.float    "yearly_interest"
    t.string   "interest_notes"
    t.string   "end_conditions"
    t.float    "management_fee"
    t.string   "special_notes"
    t.string   "special_sales"
    t.string   "buy_link"
  end

  create_table "banks", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "currencies", :force => true do |t|
    t.string   "code"
    t.string   "desc"
    t.float    "rate_to_usd"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "funds", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "company"
    t.float    "unit_value"
    t.float    "unit_value_total"
    t.float    "increment_rate"
    t.float    "increment_value"
    t.string   "managers"
    t.boolean  "open"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "transaction_categories", :force => true do |t|
    t.string   "name"
    t.integer  "transaction_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "transactions", :force => true do |t|
    t.float    "amount"
    t.string   "description"
    t.integer  "transaction_category_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "account_id"
    t.integer  "transaction_type"
    t.integer  "link_account_id"
    t.integer  "link_transaction_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
