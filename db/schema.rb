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

ActiveRecord::Schema[8.0].define(version: 2025_04_06_120242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.decimal "hourly_salary", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.bigint "user_id"
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["title"], name: "index_jobs_on_title", opclass: :gin_trgm_ops, using: :gin
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "jobs_languages", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "language_id"], name: "index_jobs_languages_on_job_id_and_language_id", unique: true
    t.index ["job_id"], name: "index_jobs_languages_on_job_id"
    t.index ["language_id"], name: "index_jobs_languages_on_language_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.datetime "start_datetime", null: false
    t.datetime "end_datetime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "start_datetime"], name: "index_shifts_on_job_id_and_start_datetime"
    t.index ["job_id"], name: "index_shifts_on_job_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "users"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "users"
  add_foreign_key "jobs_languages", "jobs"
  add_foreign_key "jobs_languages", "languages"
  add_foreign_key "shifts", "jobs"
  add_foreign_key "users", "companies"
end
