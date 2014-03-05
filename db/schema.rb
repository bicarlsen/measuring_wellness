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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140305011730) do

  create_table "analyte_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_partitions"
  end

  create_table "analytes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "status"
    t.string   "test_center"
    t.string   "promotion_code"
  end

  add_index "orders", ["promotion_code"], name: "index_orders_on_promotion_code"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "rules", force: true do |t|
    t.integer  "analyte_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "partitions"
    t.integer  "default_weight"
    t.integer  "analyte_id"
  end

  add_index "rules", ["analyte_group_id"], name: "index_rules_on_analyte_group_id"

  create_table "settings", force: true do |t|
    t.string "type"
    t.string "key"
    t.text   "value"
  end

  add_index "settings", ["type"], name: "index_settings_on_type"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.date     "birth_date"
    t.float    "weight"
    t.float    "height"
    t.string   "gender"
    t.string   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.boolean  "terms_of_use"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true

end
