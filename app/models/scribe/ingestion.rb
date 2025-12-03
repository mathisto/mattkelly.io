module Scribe
  class Ingestion < ::ApplicationRecord
    self.table_name = "scribe_ingestions"

    # Associations
    belongs_to :workout, class_name: "Scribe::Workout", optional: true
    belongs_to :ingestion_event, class_name: "Scribe::IngestionEvent", optional: true
    belongs_to :sleep_event, class_name: "Scribe::SleepEvent", optional: true
    belongs_to :journal_entry, class_name: "Scribe::JournalEntry", optional: true

    # Validations
    validates :raw_utterance, presence: true
    validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
    validates :confidence_score, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true }
    validates :tokens_used, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

    # Scopes
    scope :pending, -> { where(status: "pending") }
    scope :processing, -> { where(status: "processing") }
    scope :completed, -> { where(status: "completed") }
    scope :failed, -> { where(status: "failed") }
    scope :recent, -> { order(created_at: :desc) }
    scope :with_errors, -> { where.not(error_message: nil) }
    scope :needs_retry, -> { failed.where("created_at > ?", 1.hour.ago) }

    # Status constants
    STATUSES = %w[pending processing completed failed].freeze

    # Model selection constants
    MODEL_HAIKU = "claude-3-5-haiku-20241022".freeze
    MODEL_SONNET = "claude-3-7-sonnet-20250219".freeze

    def self.ransackable_attributes(auth_object = nil)
      %w[raw_utterance status confidence_score model_used tokens_used created_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[workout ingestion_event sleep_event journal_entry]
    end

    # Callbacks
    after_create_commit :broadcast_created
    after_update_commit :broadcast_updated

    # State machine methods
    def mark_processing!
      update!(status: "processing")
    end

    def mark_completed!(workout:, confidence:, tokens:)
      update!(
        status: "completed",
        workout: workout,
        confidence_score: confidence,
        tokens_used: tokens
      )
    end

    def mark_failed!(error_message)
      update!(
        status: "failed",
        error_message: error_message
      )
    end

    # Helper methods
    def status_badge_color
      case status
      when "completed" then "green"
      when "processing" then "blue"
      when "failed" then "red"
      else "gray"
      end
    end

    def model_display_name
      case model_used
      when MODEL_HAIKU then "Haiku (Fast)"
      when MODEL_SONNET then "Sonnet (Complex)"
      else model_used || "Unknown"
      end
    end

    def complexity_score
      # Simple heuristic: longer utterances or multiple data points = more complex
      return 0 unless raw_utterance

      utterance_length = raw_utterance.length
      data_point_indicators = raw_utterance.scan(/\d+/).count

      # Base score from length
      score = utterance_length / 10.0

      # Boost for multiple data points
      score += data_point_indicators * 5

      score
    end

    def should_use_sonnet?
      # Use Sonnet for complex utterances
      complexity_score > 50
    end

    def suggested_model
      should_use_sonnet? ? MODEL_SONNET : MODEL_HAIKU
    end

    # Status check helpers
    def pending?
      status == "pending"
    end

    def processing?
      status == "processing"
    end

    def completed?
      status == "completed"
    end

    def failed?
      status == "failed"
    end

    def processing_time
      return nil unless completed? && updated_at && created_at

      (updated_at - created_at).round(2)
    end

    def formatted_processing_time
      return nil unless processing_time

      if processing_time < 1
        "#{(processing_time * 1000).round(0)}ms"
      else
        "#{processing_time.round(2)}s"
      end
    end

    def retryable?
      failed? && created_at > 1.hour.ago
    end

    # Get the parsed event (workout, ingestion_event, sleep_event, or journal_entry)
    def parsed_event
      workout || ingestion_event || sleep_event || journal_entry
    end

    # Determine the event type
    def event_type
      return "workout" if workout
      return "ingestion" if ingestion_event
      return "sleep" if sleep_event
      return "journal" if journal_entry
      nil
    end

    # Generate a human-readable parsed data summary
    def parsed_summary
      return nil unless parsed_event

      case event_type
      when "workout"
        workout_summary
      when "ingestion"
        ingestion_summary
      when "sleep"
        sleep_summary
      when "journal"
        journal_summary
      end
    end

    private

    def workout_summary
      parts = []
      parts << "#{workout.activity_type}"
      parts << "#{workout.formatted_distance}" if workout.distance_meters
      parts << "#{workout.formatted_duration}" if workout.duration_seconds
      parts << "#{workout.calories_burned} cal" if workout.calories_burned
      parts << "#{workout.formatted_water}" if workout.water_ml
      parts << "#{workout.protein_grams}g protein" if workout.protein_grams
      parts << "#{workout.formatted_weight}" if workout.weight_grams
      parts << "#{workout.heart_rate_avg} bpm" if workout.heart_rate_avg
      parts.join(" • ")
    end

    def ingestion_summary
      parts = []
      parts << "#{ingestion_event.item_name}"
      parts << "#{ingestion_event.formatted_normalized_quantity}" if ingestion_event.normalized_quantity
      parts << "#{ingestion_event.formatted_calories}" if ingestion_event.calories
      parts << "#{ingestion_event.active_ingredient_mg}mg #{ingestion_event.substance_category}" if ingestion_event.active_ingredient_mg
      parts.join(" • ")
    end

    def sleep_summary
      parts = []
      parts << "#{sleep_event.event_type.humanize}"
      parts << "#{sleep_event.formatted_duration}" if sleep_event.duration_minutes
      parts.join(" • ")
    end

    def journal_summary
      "#{journal_entry.short_content(80)} (#{journal_entry.word_count} words)"
    end

    # Keep broadcast methods below
    private

    def broadcast_created
      broadcast_to_channel("created")
    end

    def broadcast_updated
      broadcast_to_channel("updated")
    end

    def broadcast_to_channel(action)
      # Reload to ensure we have latest associations
      reload

      Rails.logger.info "[Ingestion] Broadcasting #{action} for ingestion ##{id}"

      ActionCable.server.broadcast(
        "scribe_ingestions",
        {
          action: action,
          id: id,
          html: ApplicationController.render(
            partial: "scribe/ingestions/table_row",
            locals: { ingestion: self }
          )
        }
      )

      Rails.logger.info "[Ingestion] Broadcast completed for ingestion ##{id}"
    rescue => e
      Rails.logger.error "[Ingestion] Failed to broadcast #{action}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
