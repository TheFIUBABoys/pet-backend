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

ActiveRecord::Schema.define(version: 20151004160813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pet_images", force: true do |t|
    t.integer  "pet_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pet_images", ["pet_id"], name: "index_pet_images_on_pet_id", using: :btree

  create_table "pet_question_answers", force: true do |t|
    t.integer  "pet_question_id"
    t.text     "body",            default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pet_question_answers", ["pet_question_id"], name: "index_pet_question_answers_on_pet_question_id", using: :btree

  create_table "pet_questions", force: true do |t|
    t.integer  "pet_id"
    t.integer  "user_id"
    t.text     "body",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pet_questions", ["pet_id"], name: "index_pet_questions_on_pet_id", using: :btree
  add_index "pet_questions", ["user_id"], name: "index_pet_questions_on_user_id", using: :btree

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

  create_table "rails_push_notifications_apns_apps", force: true do |t|
    t.text     "apns_dev_cert"
    t.text     "apns_prod_cert"
    t.boolean  "sandbox_mode"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "rails_push_notifications_gcm_apps", force: true do |t|
    t.string   "gcm_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_mpns_apps", force: true do |t|
    t.text     "cert"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_notifications", force: true do |t|
    t.text     "destinations"
    t.integer  "app_id"
    t.string   "app_type"
    t.text     "data"
    t.text     "results"
    t.integer  "success"
    t.integer  "failed"
    t.boolean  "sent",         default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "rails_push_notifications_notifications", ["app_id", "app_type", "sent"], name: "app_and_sent_index_on_rails_push_notifications", using: :btree

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
    t.string   "device_id",              default: "", null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
