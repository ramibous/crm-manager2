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

ActiveRecord::Schema[7.1].define(version: 2024_09_06_021623) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.string "title"
    t.datetime "scheduled_at"
    t.bigint "client_id", null: false
    t.bigint "staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.index ["client_id"], name: "index_appointments_on_client_id"
    t.index ["staff_id"], name: "index_appointments_on_staff_id"
  end

  create_table "campaign_assignments", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "staff_id"
    t.string "task_status"
    t.boolean "message_sent", default: false
    t.index ["campaign_id"], name: "index_campaign_assignments_on_campaign_id"
    t.index ["client_id"], name: "index_campaign_assignments_on_client_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.bigint "staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "image"
    t.index ["staff_id"], name: "index_campaigns_on_staff_id"
  end

  create_table "campaigns_staffs", id: false, force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "staff_id", null: false
    t.index ["campaign_id", "staff_id"], name: "index_campaigns_staffs_on_campaign_id_and_staff_id"
    t.index ["staff_id", "campaign_id"], name: "index_campaigns_staffs_on_staff_id_and_campaign_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "email"
    t.date "birthday"
    t.text "address"
    t.string "phone"
    t.string "home_number"
    t.string "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "staff_id"
    t.string "customer_code"
    t.string "type"
    t.string "postal_code"
    t.text "notes"
    t.string "store_location"
    t.string "gender"
    t.bigint "manager_id"
    t.index ["client_id"], name: "index_clients_on_client_id", unique: true
  end

  create_table "interactions", force: :cascade do |t|
    t.string "interaction_type"
    t.bigint "client_id", null: false
    t.bigint "staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["client_id"], name: "index_interactions_on_client_id"
    t.index ["staff_id"], name: "index_interactions_on_staff_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.bigint "client_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_messages_on_campaign_id"
    t.index ["client_id"], name: "index_messages_on_client_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "product_name"
    t.decimal "amount"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store"
    t.index ["client_id"], name: "index_purchases_on_client_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "due_date"
    t.bigint "staff_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_tasks_on_campaign_id"
    t.index ["staff_id"], name: "index_tasks_on_staff_id"
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "item_name"
    t.string "item_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "size"
    t.string "color"
    t.text "note"
    t.index ["client_id"], name: "index_wishlist_items_on_client_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "clients"
  add_foreign_key "appointments", "staffs"
  add_foreign_key "campaign_assignments", "campaigns"
  add_foreign_key "campaign_assignments", "clients"
  add_foreign_key "campaign_assignments", "staffs"
  add_foreign_key "campaigns", "staffs"
  add_foreign_key "interactions", "clients"
  add_foreign_key "interactions", "staffs"
  add_foreign_key "messages", "campaigns"
  add_foreign_key "messages", "clients"
  add_foreign_key "purchases", "clients"
  add_foreign_key "tasks", "campaigns"
  add_foreign_key "tasks", "staffs"
  add_foreign_key "wishlist_items", "clients"
end
