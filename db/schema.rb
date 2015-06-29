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

ActiveRecord::Schema.define(version: 20150629190231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "provider",   limit: 255, null: false
    t.string   "uid",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", using: :btree

  create_table "cards", force: :cascade do |t|
    t.text     "original_text"
    t.text     "translated_text"
    t.datetime "review_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                    null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "deck_id",                                    null: false
    t.integer  "stage",                          default: 1, null: false
    t.integer  "try",                            default: 1, null: false
  end

  create_table "decks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password", limit: 255
    t.string   "salt",             limit: 255
    t.integer  "current_deck_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
