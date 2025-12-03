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

ActiveRecord::Schema[8.1].define(version: 2025_12_03_190749) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "domain"
    t.string "hubspot_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.text "body_html"
    t.text "body_text"
    t.datetime "created_at", null: false
    t.string "email_direction"
    t.string "email_status"
    t.string "from_email"
    t.integer "onboarding_id", null: false
    t.string "subject"
    t.datetime "timestamp"
    t.string "to_email"
    t.datetime "updated_at", null: false
    t.index ["onboarding_id"], name: "index_emails_on_onboarding_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.string "hubspot_id"
    t.text "internal_notes"
    t.integer "onboarding_id", null: false
    t.string "outcome"
    t.datetime "start_time"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["onboarding_id"], name: "index_meetings_on_onboarding_id"
  end

  create_table "onboardings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "due_date"
    t.string "hubspot_id"
    t.datetime "hubspot_synced_at"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_onboardings_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "firstname"
    t.string "hubspot_id"
    t.string "jobtitle"
    t.string "lastname"
    t.integer "onboarding_id", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["onboarding_id"], name: "index_participants_on_onboarding_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "body"
    t.datetime "completion_date"
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.string "hubspot_id"
    t.integer "onboarding_id", null: false
    t.string "status"
    t.string "subject"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["onboarding_id"], name: "index_tasks_on_onboarding_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "emails", "onboardings"
  add_foreign_key "meetings", "onboardings"
  add_foreign_key "onboardings", "users"
  add_foreign_key "participants", "onboardings"
  add_foreign_key "tasks", "onboardings"
end
