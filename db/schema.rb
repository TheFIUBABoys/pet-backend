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

ActiveRecord::Schema.define(version: 20151004150350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pet_images", force: true do |t|
    t.integer  "pet_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pet_images", ["pet_id"], name: "index_pet_images_on_pet_id", using: :btree

  create_table "pet_photos", force: true do |t|
    t.integer  "pet_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pet_photos", ["pet_id"], name: "index_pet_photos_on_pet_id", using: :btree

  create_table "pet_videos", force: true do |t|
    t.integer  "pet_id"
    t.string   "url",        default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pet_videos", ["pet_id"], name: "index_pet_videos_on_pet_id", using: :btree

  create_table "pets", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "needs_transit_home", default: false, null: false
    t.boolean  "published",          default: false, null: false
    t.integer  "user_id"
    t.string   "location",           default: ""
    t.string   "colors",             default: ""
    t.string   "gender"
    t.text     "metadata",           default: ""
    t.boolean  "vaccinated",         default: false
    t.integer  "age"
    t.boolean  "pet_friendly",       default: false
    t.boolean  "children_friendly",  default: false
  end

  add_index "pets", ["type"], name: "index_pets_on_type", using: :btree
  add_index "pets", ["user_id"], name: "index_pets_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_id"
    t.string   "facebook_token"
    t.string   "authentication_token"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
