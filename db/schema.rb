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

ActiveRecord::Schema[7.0].define(version: 2023_11_05_145428) do
  create_table "cell_types", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cells", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "coord", null: false
    t.integer "radius", null: false
    t.integer "cell_type_id", null: false
    t.index ["cell_type_id"], name: "cell_type_foreign_key"
    t.index ["coord"], name: "cells_point_idx", length: 32, type: :spatial
  end

  create_table "cells_types", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "countries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.float "lat", null: false
    t.float "lon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "task_id"
    t.text "res_data", size: :long, collation: "utf8mb4_bin"
    t.index ["task_id"], name: "task_id"
    t.check_constraint "json_valid(`res_data`)", name: "res_data"
  end

  create_table "tasks", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "base_filename", limit: 64, null: false
    t.text "config", size: :long, null: false, collation: "utf8mb4_bin"
    t.text "geojson", size: :long, null: false, collation: "utf8mb4_bin"
    t.float "lat", null: false
    t.float "lon", null: false
    t.datetime "requested_at", precision: nil
    t.string "description", limit: 100
    t.integer "requests", null: false
    t.index ["base_filename"], name: "base_filename", unique: true
    t.index ["user_id"], name: "user_id"
    t.check_constraint "json_valid(`config`)", name: "config"
    t.check_constraint "json_valid(`geojson`)", name: "geojson"
  end

  create_table "users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "admin", null: false
    t.string "email", limit: 100, null: false
    t.string "password_digest", limit: 256, null: false
    t.string "name", limit: 100, null: false
    t.string "company", limit: 100
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }
    t.datetime "last_access_at"
    t.index ["email"], name: "email", unique: true
  end

  create_table "workers", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "token", limit: 64, null: false
    t.string "name", limit: 50, null: false
    t.string "description", limit: 200
    t.datetime "created_at", precision: nil, default: -> { "current_timestamp()" }, null: false
    t.integer "tasks", null: false
    t.datetime "last_task_at", precision: nil
    t.float "total_time", null: false
    t.index ["token"], name: "token", unique: true
  end

  add_foreign_key "results", "tasks", name: "results_ibfk_1"
  add_foreign_key "tasks", "users", name: "tasks_ibfk_1"
end
