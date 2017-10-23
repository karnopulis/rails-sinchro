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

ActiveRecord::Schema.define(version: 20170609101231) do

  create_table "characteristics", force: :cascade do |t|
    t.integer  "original_id"
    t.integer  "property_id"
    t.integer  "offer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.string   "scu"
    t.index ["offer_id"], name: "index_characteristics_on_offer_id"
    t.index ["property_id"], name: "index_characteristics_on_property_id"
  end

  create_table "collect_imports", force: :cascade do |t|
    t.string   "scu"
    t.string   "flat"
    t.integer  "compare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
    t.index ["compare_id"], name: "index_collect_imports_on_compare_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "compare_id"
    t.integer  "original_id"
    t.string   "flat"
    t.integer  "position"
    t.index ["compare_id"], name: "index_collections_on_compare_id"
  end

  create_table "collects", force: :cascade do |t|
    t.integer  "original_id"
    t.integer  "collection_id"
    t.integer  "offer_id"
    t.integer  "compare_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["collection_id"], name: "index_collects_on_collection_id"
    t.index ["compare_id"], name: "index_collects_on_compare_id"
    t.index ["offer_id"], name: "index_collects_on_offer_id"
  end

  create_table "compares", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "site_id"
    t.integer  "category_original_id"
    t.integer  "global_parent_id"
    t.string   "state"
    t.index ["site_id"], name: "index_compares_on_site_id"
  end

  create_table "edit_collections", force: :cascade do |t|
    t.string   "flat"
    t.integer  "result_id"
    t.integer  "position"
    t.integer  "original_id"
    t.string   "state"
    t.string   "error"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["result_id"], name: "index_edit_collections_on_result_id"
  end

  create_table "edit_offers", force: :cascade do |t|
    t.string   "scu"
    t.string   "title"
    t.integer  "original_id"
    t.string   "state"
    t.text     "error"
    t.integer  "result_id"
    t.integer  "new_offer_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "flat"
    t.string   "sort_weight"
    t.index ["new_offer_id"], name: "index_edit_offers_on_new_offer_id"
    t.index ["result_id"], name: "index_edit_offers_on_result_id"
  end

  create_table "edit_variants", force: :cascade do |t|
    t.string   "scu"
    t.integer  "quantity"
    t.integer  "original_id"
    t.string   "state"
    t.text     "error"
    t.integer  "result_id"
    t.integer  "new_offer_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "flat"
    t.index ["new_offer_id"], name: "index_edit_variants_on_new_offer_id"
    t.index ["result_id"], name: "index_edit_variants_on_result_id"
  end

  create_table "handler_errors", force: :cascade do |t|
    t.integer  "compare_id"
    t.string   "model"
    t.integer  "model_id"
    t.string   "message"
    t.integer  "tryes_left"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compare_id"], name: "index_handler_errors_on_compare_id"
  end

  create_table "insales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_collections", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "title"
    t.string   "collection_flat"
    t.string   "state"
    t.text     "error"
    t.integer  "new_parent_id"
    t.integer  "result_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "position"
    t.index ["new_parent_id"], name: "index_new_collections_on_new_parent_id"
    t.index ["result_id"], name: "index_new_collections_on_result_id"
  end

  create_table "new_collects", force: :cascade do |t|
    t.integer  "collection_original_id"
    t.integer  "product_original_id"
    t.string   "collection_flat"
    t.string   "product_scu"
    t.string   "state"
    t.text     "error"
    t.integer  "new_collection_id"
    t.integer  "new_product_id"
    t.integer  "result_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["new_collection_id"], name: "index_new_collects_on_new_collection_id"
    t.index ["new_product_id"], name: "index_new_collects_on_new_product_id"
    t.index ["result_id"], name: "index_new_collects_on_result_id"
  end

  create_table "new_offers", force: :cascade do |t|
    t.string   "state"
    t.text     "error"
    t.integer  "result_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "original_id"
    t.string   "scu"
    t.index ["result_id"], name: "index_new_offers_on_result_id"
  end

  create_table "new_pictures", force: :cascade do |t|
    t.string   "url"
    t.string   "scu"
    t.string   "original_offer_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "result_id"
    t.string   "state"
    t.string   "error"
    t.integer  "new_offer_id"
    t.integer  "position"
    t.integer  "size"
    t.index ["new_offer_id"], name: "index_new_pictures_on_new_offer_id"
    t.index ["result_id"], name: "index_new_pictures_on_result_id"
  end

  create_table "offer_imports", force: :cascade do |t|
    t.string   "title"
    t.string   "prop_flat"
    t.float    "sort_order"
    t.string   "scu"
    t.integer  "compare_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "image_status"
    t.index ["compare_id"], name: "index_offer_imports_on_compare_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string   "scu"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "compare_id"
    t.integer  "original_id"
    t.string   "title"
    t.string   "flat"
    t.string   "image_status"
    t.float    "sort_weight"
    t.index ["compare_id"], name: "index_offers_on_compare_id"
  end

  create_table "old_collections", force: :cascade do |t|
    t.integer  "collection_original_id"
    t.string   "state"
    t.text     "error"
    t.string   "collection_flat"
    t.integer  "old_collection_id"
    t.integer  "result_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["old_collection_id"], name: "index_old_collections_on_old_collection_id"
    t.index ["result_id"], name: "index_old_collections_on_result_id"
  end

  create_table "old_collects", force: :cascade do |t|
    t.integer  "collect_original_id"
    t.string   "state"
    t.text     "error"
    t.string   "collection_flat"
    t.string   "product_scu"
    t.integer  "result_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["result_id"], name: "index_old_collects_on_result_id"
  end

  create_table "old_offers", force: :cascade do |t|
    t.string   "scu"
    t.integer  "original_id"
    t.string   "state"
    t.text     "error"
    t.integer  "result_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["result_id"], name: "index_old_offers_on_result_id"
  end

  create_table "old_pictures", force: :cascade do |t|
    t.string   "scu"
    t.string   "original_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "result_id"
    t.string   "state"
    t.string   "error"
    t.integer  "original_offer_id"
    t.integer  "position"
    t.index ["result_id"], name: "index_old_pictures_on_result_id"
  end

  create_table "outsales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "picture_imports", force: :cascade do |t|
    t.string   "url"
    t.integer  "offer_import_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "scu"
    t.integer  "position"
    t.string   "filename"
    t.integer  "size"
    t.index ["offer_import_id"], name: "index_picture_imports_on_offer_import_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "url"
    t.integer  "offer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "original_id"
    t.string   "scu"
    t.integer  "position"
    t.string   "filename"
    t.integer  "size"
    t.index ["offer_id"], name: "index_pictures_on_offer_id"
  end

  create_table "prices", force: :cascade do |t|
    t.float    "value"
    t.integer  "variant_id"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sku"
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "original_id"
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "compare_id"
    t.index ["compare_id"], name: "index_properties_on_compare_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "compare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compare_id"], name: "index_results_on_compare_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "site_login"
    t.string   "site_pass"
    t.string   "home_login"
    t.string   "home_pass"
    t.string   "site_global_parent"
    t.string   "csv_collection_order"
    t.string   "csv_variant_order"
    t.string   "site_variant_order"
    t.string   "csv_offer_order"
    t.string   "site_offer_order"
    t.string   "sort_order"
    t.string   "scu_field"
    t.string   "quantity_field"
    t.string   "title_field"
    t.string   "csv_images_order"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "home_ftp"
    t.string   "home_file_name"
    t.string   "site_collections_order"
    t.string   "csv_collections_order"
    t.string   "model"
    t.string   "soap_login"
    t.string   "soap_pass"
    t.string   "soap_url"
  end

  create_table "status_trackers", force: :cascade do |t|
    t.integer  "compare_id"
    t.datetime "date"
    t.string   "level"
    t.integer  "thread"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compare_id"], name: "index_status_trackers_on_compare_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variant_imports", force: :cascade do |t|
    t.integer  "quantity"
    t.string   "scu"
    t.string   "pric_flat"
    t.integer  "compare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compare_id"], name: "index_variant_imports_on_compare_id"
  end

  create_table "variants", force: :cascade do |t|
    t.string   "sku"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "original_id"
    t.integer  "offer_id"
    t.string   "flat"
    t.integer  "compare_id"
    t.index ["compare_id"], name: "index_variants_on_compare_id"
    t.index ["offer_id"], name: "index_variants_on_offer_id"
  end

end
