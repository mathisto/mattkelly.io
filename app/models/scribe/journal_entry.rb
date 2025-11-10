module Scribe
  class JournalEntry < ::ApplicationRecord
    self.table_name = "scribe_journal_entries"

    # Associations
    has_one :ingestion, class_name: "Scribe::Ingestion", foreign_key: :journal_entry_id

    # Validations
    validates :content, presence: true
    validates :confidence_score, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true }

    # Scopes
    scope :recent, -> { order(occurred_at: :desc, created_at: :desc) }
    scope :by_date, ->(date) { where("DATE(occurred_at) = ?", date) }

    # Callbacks
    after_create_commit :broadcast_created
    after_update_commit :broadcast_updated

    def self.ransackable_attributes(auth_object = nil)
      %w[content occurred_at created_at confidence_score]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[ingestion]
    end

    # Display helpers
    def type_icon
      "📔"
    end

    def short_content(length = 100)
      return content if content.length <= length
      "#{content[0...length]}..."
    end

    def formatted_occurred_at
      return "Just now" unless occurred_at
      occurred_at.strftime("%b %d, %Y at %I:%M %p")
    end

    def word_count
      content.split.size
    end

    def character_count
      content.length
    end

    private

    def broadcast_created
      broadcast_to_channel("created")
    end

    def broadcast_updated
      broadcast_to_channel("updated")
    end

    def broadcast_to_channel(action)
      reload

      Rails.logger.info "[JournalEntry] Broadcasting #{action} for entry ##{id}"

      ActionCable.server.broadcast(
        "scribe_ingestions",
        {
          action: action,
          id: ingestion&.id,
          html: ApplicationController.render(
            partial: "scribe/ingestions/table_row",
            locals: { ingestion: ingestion }
          )
        }
      )

      Rails.logger.info "[JournalEntry] Broadcast completed for entry ##{id}"
    rescue StandardError => e
      Rails.logger.error "[JournalEntry] Failed to broadcast #{action}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
