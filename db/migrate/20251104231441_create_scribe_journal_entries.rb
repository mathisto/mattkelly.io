class CreateScribeJournalEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :scribe_journal_entries do |t|
      t.text :content, null: false
      t.datetime :occurred_at
      t.text :original_utterance
      t.float :confidence_score, default: 1.0

      t.timestamps
    end

    add_index :scribe_journal_entries, :occurred_at
    add_index :scribe_journal_entries, :created_at
  end
end
