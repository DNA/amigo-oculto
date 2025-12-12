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

ActiveRecord::Schema[8.1].define(version: 2025_12_11_235019) do
  create_table "draws", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "giver_id", null: false
    t.integer "group_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "updated_at", null: false
    t.index ["giver_id"], name: "index_draws_on_giver_id"
    t.index ["group_id", "giver_id"], name: "index_draws_on_group_id_and_giver_id", unique: true
    t.index ["group_id", "receiver_id"], name: "index_draws_on_group_id_and_receiver_id", unique: true
    t.index ["group_id"], name: "index_draws_on_group_id"
    t.index ["receiver_id"], name: "index_draws_on_receiver_id"
  end

  create_table "exclusions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "excluded_person_id", null: false
    t.integer "group_id", null: false
    t.integer "person_id", null: false
    t.datetime "updated_at", null: false
    t.index ["excluded_person_id"], name: "index_exclusions_on_excluded_person_id"
    t.index ["group_id"], name: "index_exclusions_on_group_id"
    t.index ["person_id"], name: "index_exclusions_on_person_id"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "group_id", null: false
    t.string "name"
    t.integer "parent_id"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_people_on_group_id"
    t.index ["parent_id"], name: "index_people_on_parent_id"
  end

  add_foreign_key "draws", "groups"
  add_foreign_key "draws", "people", column: "giver_id"
  add_foreign_key "draws", "people", column: "receiver_id"
  add_foreign_key "exclusions", "groups"
  add_foreign_key "exclusions", "people"
  add_foreign_key "exclusions", "people", column: "excluded_person_id"
  add_foreign_key "people", "groups"
  add_foreign_key "people", "people", column: "parent_id"
end
