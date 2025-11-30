class CreateScribeSleepEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :scribe_sleep_events do |t|
      # Event type
      t.string :event_type, null: false        # "went_to_bed", "fell_asleep", "woke_up", "got_up"

      # Timing
      t.datetime :occurred_at, null: false     # When the event happened (can be retroactive)
      t.integer :duration_minutes              # Calculated from paired events (sleep duration)

      # Quality tracking
      t.decimal :quality_score, precision: 3, scale: 2  # 0-1, if user provides feedback

      # Metadata
      t.text :original_utterance               # "woke up at 7am"
      t.text :notes                            # Additional context
      t.decimal :confidence_score, precision: 3, scale: 2  # AI confidence (0-1)
      t.boolean :needs_review, default: false

      # Sleep session pairing - links woke_up events to went_to_bed events
      t.references :paired_sleep_event, foreign_key: { to_table: :scribe_sleep_events }, null: true

      t.timestamps
    end

    # Indexes for common queries
    add_index :scribe_sleep_events, :event_type
    add_index :scribe_sleep_events, :occurred_at
    add_index :scribe_sleep_events, :needs_review
    add_index :scribe_sleep_events, :created_at
  end
end
