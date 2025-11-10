class AddPolymorphicToScribeIngestions < ActiveRecord::Migration[8.0]
  def change
    # Add references for new event types
    add_reference :scribe_ingestions, :ingestion_event,
                  foreign_key: { to_table: :scribe_ingestion_events },
                  null: true

    add_reference :scribe_ingestions, :sleep_event,
                  foreign_key: { to_table: :scribe_sleep_events },
                  null: true
  end
end
