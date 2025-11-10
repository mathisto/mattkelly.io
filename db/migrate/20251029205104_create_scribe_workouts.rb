class CreateScribeWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :scribe_workouts do |t|
      # Core fields
      t.string :activity_type, null: false  # run, swim, bike, walk, etc.
      t.integer :duration_seconds
      t.integer :distance_meters
      t.integer :calories_burned
      t.integer :heart_rate_avg

      # Metric tracking (all integers, metric units)
      t.integer :water_ml  # milliliters
      t.integer :protein_grams
      t.integer :weight_grams  # body weight

      # Temporal data
      t.datetime :performed_at  # When the activity happened (can be past)

      # Metadata (flexible JSON for additional data)
      t.json :metadata, default: {}

      # Source tracking
      t.boolean :needs_review, default: false, null: false
      t.float :confidence_score  # 0.0-1.0 from LLM parsing
      t.text :original_utterance  # Keep original input for review

      t.timestamps
    end

    # Indexes for common queries
    add_index :scribe_workouts, :activity_type
    add_index :scribe_workouts, :performed_at
    add_index :scribe_workouts, :needs_review
    add_index :scribe_workouts, :created_at
  end
end
