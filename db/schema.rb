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

ActiveRecord::Schema[8.0].define(version: 2025_11_04_231457) do
  create_table "scribe_ingestion_events", force: :cascade do |t|
    t.string "ingestion_type", null: false
    t.string "item_name", null: false
    t.decimal "quantity", precision: 10, scale: 2
    t.string "unit"
    t.decimal "normalized_quantity", precision: 10, scale: 2
    t.string "normalized_unit"
    t.integer "calories"
    t.integer "protein_grams"
    t.integer "carbs_grams"
    t.integer "fat_grams"
    t.string "substance_category"
    t.decimal "active_ingredient_mg", precision: 10, scale: 2
    t.datetime "consumed_at", null: false
    t.text "original_utterance"
    t.text "notes"
    t.decimal "confidence_score", precision: 3, scale: 2
    t.boolean "needs_review", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumed_at"], name: "index_scribe_ingestion_events_on_consumed_at"
    t.index ["created_at"], name: "index_scribe_ingestion_events_on_created_at"
    t.index ["ingestion_type"], name: "index_scribe_ingestion_events_on_ingestion_type"
    t.index ["needs_review"], name: "index_scribe_ingestion_events_on_needs_review"
    t.index ["substance_category"], name: "index_scribe_ingestion_events_on_substance_category"
  end

  create_table "scribe_ingestions", force: :cascade do |t|
    t.text "raw_utterance", null: false
    t.string "status", default: "pending", null: false
    t.float "confidence_score"
    t.json "parsed_data", default: {}
    t.text "error_message"
    t.string "model_used"
    t.integer "tokens_used"
    t.integer "workout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ingestion_event_id"
    t.integer "sleep_event_id"
    t.integer "journal_entry_id"
    t.index ["created_at"], name: "index_scribe_ingestions_on_created_at"
    t.index ["ingestion_event_id"], name: "index_scribe_ingestions_on_ingestion_event_id"
    t.index ["journal_entry_id"], name: "index_scribe_ingestions_on_journal_entry_id"
    t.index ["sleep_event_id"], name: "index_scribe_ingestions_on_sleep_event_id"
    t.index ["status"], name: "index_scribe_ingestions_on_status"
    t.index ["workout_id"], name: "index_scribe_ingestions_on_workout_id"
  end

  create_table "scribe_journal_entries", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "occurred_at"
    t.text "original_utterance"
    t.float "confidence_score", default: 1.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_scribe_journal_entries_on_created_at"
    t.index ["occurred_at"], name: "index_scribe_journal_entries_on_occurred_at"
  end

  create_table "scribe_sleep_events", force: :cascade do |t|
    t.string "event_type", null: false
    t.datetime "occurred_at", null: false
    t.integer "duration_minutes"
    t.decimal "quality_score", precision: 3, scale: 2
    t.text "original_utterance"
    t.text "notes"
    t.decimal "confidence_score", precision: 3, scale: 2
    t.boolean "needs_review", default: false
    t.integer "paired_sleep_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_scribe_sleep_events_on_created_at"
    t.index ["event_type"], name: "index_scribe_sleep_events_on_event_type"
    t.index ["needs_review"], name: "index_scribe_sleep_events_on_needs_review"
    t.index ["occurred_at"], name: "index_scribe_sleep_events_on_occurred_at"
    t.index ["paired_sleep_event_id"], name: "index_scribe_sleep_events_on_paired_sleep_event_id"
  end

  create_table "scribe_workouts", force: :cascade do |t|
    t.string "activity_type", null: false
    t.integer "duration_seconds"
    t.integer "distance_meters"
    t.integer "calories_burned"
    t.integer "heart_rate_avg"
    t.integer "water_ml"
    t.integer "protein_grams"
    t.integer "weight_grams"
    t.datetime "performed_at"
    t.json "metadata", default: {}
    t.boolean "needs_review", default: false, null: false
    t.float "confidence_score"
    t.text "original_utterance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_type"], name: "index_scribe_workouts_on_activity_type"
    t.index ["created_at"], name: "index_scribe_workouts_on_created_at"
    t.index ["needs_review"], name: "index_scribe_workouts_on_needs_review"
    t.index ["performed_at"], name: "index_scribe_workouts_on_performed_at"
  end

  add_foreign_key "scribe_ingestions", "scribe_ingestion_events", column: "ingestion_event_id"
  add_foreign_key "scribe_ingestions", "scribe_journal_entries", column: "journal_entry_id"
  add_foreign_key "scribe_ingestions", "scribe_sleep_events", column: "sleep_event_id"
  add_foreign_key "scribe_ingestions", "scribe_workouts", column: "workout_id"
  add_foreign_key "scribe_sleep_events", "scribe_sleep_events", column: "paired_sleep_event_id"
end
