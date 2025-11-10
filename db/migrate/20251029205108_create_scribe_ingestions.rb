class CreateScribeIngestions < ActiveRecord::Migration[8.0]
  def change
    create_table :scribe_ingestions do |t|
      # Raw input
      t.text :raw_utterance, null: false

      # Parsing metadata
      t.string :status, null: false, default: "pending"  # pending, processing, completed, failed
      t.float :confidence_score  # Overall confidence from LLM
      t.json :parsed_data, default: {}  # Structured data before creating workout
      t.text :error_message  # If parsing failed

      # Model tracking
      t.string :model_used  # Which Claude model was used
      t.integer :tokens_used  # Track API usage

      # Result tracking
      t.references :workout, foreign_key: { to_table: :scribe_workouts }, null: true

      t.timestamps
    end

    # Indexes
    add_index :scribe_ingestions, :status
    add_index :scribe_ingestions, :created_at
  end
end
