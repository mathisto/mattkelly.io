class CreateScribeIngestionEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :scribe_ingestion_events do |t|
      # Event classification
      t.string :ingestion_type, null: false    # food, beverage, medication, supplement, substance
      t.string :item_name, null: false         # "cheeseburger", "water", "Vyvanse", "THC"

      # Quantity tracking
      t.decimal :quantity, precision: 10, scale: 2
      t.string :unit                           # "piece", "ounces", "mg", "serving", "session"
      t.decimal :normalized_quantity, precision: 10, scale: 2  # Converted to standard units
      t.string :normalized_unit                # "ml", "mg", "g", "kcal"

      # Nutritional data
      t.integer :calories
      t.integer :protein_grams
      t.integer :carbs_grams
      t.integer :fat_grams

      # Substance-specific tracking
      t.string :substance_category             # "caffeine", "thc", "prescription", "nicotine", "alcohol"
      t.decimal :active_ingredient_mg, precision: 10, scale: 2  # For medications/substances

      # Metadata
      t.datetime :consumed_at, null: false     # When it was consumed (can be retroactive)
      t.text :original_utterance               # "drank 32 ounces of water"
      t.text :notes                            # Additional context
      t.decimal :confidence_score, precision: 3, scale: 2  # AI confidence (0-1)
      t.boolean :needs_review, default: false

      t.timestamps
    end

    # Indexes for common queries
    add_index :scribe_ingestion_events, :ingestion_type
    add_index :scribe_ingestion_events, :consumed_at
    add_index :scribe_ingestion_events, :needs_review
    add_index :scribe_ingestion_events, :substance_category
    add_index :scribe_ingestion_events, :created_at
  end
end
