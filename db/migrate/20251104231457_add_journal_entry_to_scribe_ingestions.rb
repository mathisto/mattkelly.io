class AddJournalEntryToScribeIngestions < ActiveRecord::Migration[8.0]
  def change
    add_reference :scribe_ingestions, :journal_entry, null: true, foreign_key: { to_table: :scribe_journal_entries }
  end
end
