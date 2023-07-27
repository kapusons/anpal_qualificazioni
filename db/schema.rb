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

ActiveRecord::Schema[7.0].define(version: 2023_07_27_141849) do
  create_table "abilities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "competence_id"
    t.string "ability"
    t.string "atlante_ability"
    t.string "atlante_code_ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competence_id"], name: "index_abilities_on_competence_id"
  end

  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "attachment"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "application_atecos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.bigint "ateco_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_atecos_on_application_id"
    t.index ["ateco_id"], name: "index_application_atecos_on_ateco_id"
  end

  create_table "application_cp_istats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.bigint "cp_istat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_cp_istats_on_application_id"
    t.index ["cp_istat_id"], name: "index_application_cp_istats_on_cp_istat_id"
  end

  create_table "application_isceds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.bigint "isced_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_isceds_on_application_id"
    t.index ["isced_id"], name: "index_application_isceds_on_isced_id"
  end

  create_table "application_translations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "url"
    t.index ["application_id"], name: "index_application_translations_on_application_id"
    t.index ["locale"], name: "index_application_translations_on_locale"
  end

  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expiration_date"
    t.string "atlante_code"
    t.string "atlante_title"
    t.bigint "region_id"
    t.bigint "eqf_id"
    t.bigint "certifying_agency_id"
    t.bigint "guarantee_entity_id"
    t.string "credit"
    t.string "guarantee_process"
    t.bigint "nqf_level_id"
    t.bigint "nqf_level_in_id"
    t.bigint "nqf_level_out_id"
    t.bigint "language_id"
    t.bigint "admission_id"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.string "status"
    t.bigint "in_progress_by_id"
    t.bigint "source_id"
    t.string "rule"
    t.string "atlante_region"
    t.date "sent_at"
    t.index ["admission_id"], name: "index_applications_on_admission_id"
    t.index ["certifying_agency_id"], name: "index_applications_on_certifying_agency_id"
    t.index ["created_by_id"], name: "index_applications_on_created_by_id"
    t.index ["eqf_id"], name: "index_applications_on_eqf_id"
    t.index ["guarantee_entity_id"], name: "index_applications_on_guarantee_entity_id"
    t.index ["in_progress_by_id"], name: "index_applications_on_in_progress_by_id"
    t.index ["language_id"], name: "index_applications_on_language_id"
    t.index ["nqf_level_id"], name: "index_applications_on_nqf_level_id"
    t.index ["nqf_level_in_id"], name: "index_applications_on_nqf_level_in_id"
    t.index ["nqf_level_out_id"], name: "index_applications_on_nqf_level_out_id"
    t.index ["region_id"], name: "index_applications_on_region_id"
    t.index ["source_id"], name: "index_applications_on_source_id"
    t.index ["updated_by_id"], name: "index_applications_on_updated_by_id"
  end

  create_table "atecos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.string "code_micro"
    t.string "description_micro"
    t.string "code_category"
    t.text "description_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certifying_agencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "province_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code_catastale"
    t.string "code_numerico"
    t.index ["province_id"], name: "index_cities_on_province_id"
  end

  create_table "competences", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.string "atlante_competence"
    t.string "atlante_code_competence"
    t.string "competence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_competences_on_application_id"
  end

  create_table "cp_istats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eqfs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guarantee_entities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "isceds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "knowledges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "competence_id"
    t.string "knowledge"
    t.string "atlante_knowledge"
    t.string "atlante_code_knowledge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competence_id"], name: "index_knowledges_on_competence_id"
  end

  create_table "languages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "learning_opportunities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.string "duration"
    t.string "institution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "region_id"
    t.bigint "province_id"
    t.bigint "city_id"
    t.date "start_at"
    t.date "end_at"
    t.string "url"
    t.text "description"
    t.index ["application_id"], name: "index_learning_opportunities_on_application_id"
    t.index ["city_id"], name: "index_learning_opportunities_on_city_id"
    t.index ["province_id"], name: "index_learning_opportunities_on_province_id"
    t.index ["region_id"], name: "index_learning_opportunities_on_region_id"
  end

  create_table "learning_opportunity_manners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "learning_opportunity_id"
    t.bigint "manner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learning_opportunity_id"], name: "index_learning_opportunity_manners_on_learning_opportunity_id"
    t.index ["manner_id"], name: "index_learning_opportunity_manners_on_manner_id"
  end

  create_table "manners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "siu_id"
    t.bigint "parent_siu_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_siu_id"], name: "index_manners_on_parent_siu_id"
  end

  create_table "nqf_level_ins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nqf_level_outs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nqf_levels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provinces", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "region_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["region_id"], name: "index_provinces_on_region_id"
  end

  create_table "regions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responsibilities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "competence_id"
    t.string "responsibility"
    t.string "atlante_responsibility"
    t.string "atlante_code_responsibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competence_id"], name: "index_responsibilities_on_competence_id"
  end

  create_table "sources", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.json "meta_objects"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applications", "admissions"
  add_foreign_key "applications", "certifying_agencies"
  add_foreign_key "applications", "eqfs"
  add_foreign_key "applications", "guarantee_entities"
  add_foreign_key "applications", "languages"
  add_foreign_key "applications", "nqf_level_ins"
  add_foreign_key "applications", "nqf_level_outs"
  add_foreign_key "applications", "nqf_levels"
  add_foreign_key "applications", "regions"
  add_foreign_key "applications", "sources"
end
