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

ActiveRecord::Schema.define(version: 20170810042001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.text     "tiles",          default: "", null: false
    t.integer  "state",          default: 0,  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "layout_id",                   null: false
    t.integer  "shuffle_count",  default: 0,  null: false
    t.text     "original_tiles", default: "", null: false
    t.index ["layout_id"], name: "index_games_on_layout_id", using: :btree
    t.index ["user_id"], name: "index_games_on_user_id", using: :btree
  end

  create_table "layouts", force: :cascade do |t|
    t.string "name",           null: false
    t.text   "tile_positions", null: false
  end

  create_table "tiles", force: :cascade do |t|
    t.string  "category", null: false
    t.string  "name"
    t.integer "number"
    t.string  "suit"
    t.string  "set"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
