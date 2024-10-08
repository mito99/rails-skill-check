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

ActiveRecord::Schema.define(version: 2019_11_03_005656) do

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "user_cnt_default"
    t.integer "user_cnt_max"
    t.integer "box_cnt_default"
    t.integer "box_cnt_max"
    t.integer "monthly_fee"
    t.integer "surcharge_user_fee"
    t.integer "surcharge_box_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
