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

ActiveRecord::Schema[8.0].define(version: 2025_03_10_034453) do
  create_table "projects", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.text "technologies_used", default: "[]", null: false
    t.string "role"
    t.string "duration"
    t.string "github_url"
    t.string "live_site_url"
    t.string "screenshot_url"
    t.boolean "highlight", default: false, null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["highlight"], name: "index_projects_on_highlight"
    t.index ["position"], name: "index_projects_on_position"
  end
end
