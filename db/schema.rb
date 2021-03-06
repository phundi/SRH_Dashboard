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

ActiveRecord::Schema.define(version: 0) do

  create_table "user_role", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "role_id",       limit: 4, null: false
  end

  add_index "user_role", ["user_id"], name: "user_role_user_id_foreign", using: :btree
  add_index "user_role", ["role_id"], name: "user_role_role_id_foreign", using: :btree
  
  create_table "role", primary_key: "role_id", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 200
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "role", ["name"], name: "role_name_unique", unique: true, using: :btree

  create_table "user", primary_key: "user_id", force: :cascade do |t|
    t.string   "username",       limit: 50,              null: false
    t.string   "password",       limit: 100,             null: false
    t.string   "email",          limit: 100,             null: false
    t.string   "first_name",                    limit: 255
    t.string   "middle_name",                    limit: 255
    t.string   "last_name",                    limit: 255
    t.integer  "gender",         limit: 1,   default: 0, null: false
    t.string   "designation",    limit: 100
    t.string   "image",          limit: 100
    t.string   "remember_token", limit: 100
    t.datetime   "last_password_date"
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "user", ["username"], name: "user_username_unique", unique: true, using: :btree
  

  add_foreign_key "user_role", "role", primary_key: "role_id", name: "fk_user_role_2"
  add_foreign_key "user_role", "user", primary_key: "user_id", name: "fk_user_role_1"
end
