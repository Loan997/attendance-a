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

ActiveRecord::Schema.define(version: 20190203114524) do

  create_table "applying_states", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_basic_informations", force: :cascade do |t|
    t.time "designated_working_times"
    t.time "basic_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_cards", force: :cascade do |t|
    t.time "in_at"
    t.time "out_at"
    t.date "date"
    t.integer "user_id"
    t.string "remarks"
    t.time "end_estimated_time"
    t.string "business_outline"
    t.integer "is_overtime_applying"
    t.integer "overtime_application_target"
    t.integer "is_attendance_application_for_a_month"
    t.integer "application_targer_for_a_month"
    t.integer "is_applying_attendance_change"
    t.integer "applying_attendance_change_target"
    t.boolean "next_day"
    t.index ["date", "user_id"], name: "index_time_cards_on_date_and_user_id", unique: true
    t.index ["user_id"], name: "index_time_cards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.time "designated_working_start_time"
    t.time "designated_working_end_time"
    t.integer "employee_number"
    t.string "uid"
    t.time "basic_time"
    t.boolean "superior"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
