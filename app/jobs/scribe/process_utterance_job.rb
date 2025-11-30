# frozen_string_literal: true

module Scribe
  class ProcessUtteranceJob < ApplicationJob
    queue_as :default

    # Retry strategy for API-related errors
    retry_on Net::OpenTimeout, wait: :exponentially_longer, attempts: 3
    retry_on Net::ReadTimeout, wait: :exponentially_longer, attempts: 3
    retry_on Net::HTTPError, wait: :exponentially_longer, attempts: 3
    retry_on Timeout::Error, wait: :exponentially_longer, attempts: 3

    # Discard job after retries exhausted, marking ingestion as failed
    discard_on StandardError do |job, error|
      ingestion_id = job.arguments.first
      ingestion = Scribe::Ingestion.find_by(id: ingestion_id)

      if ingestion
        ingestion.update!(
          status: "failed",
          error_message: "Job failed after retries: #{error.message}"
        )

        Rails.logger.error "ProcessUtteranceJob failed for ingestion #{ingestion_id}: #{error.message}"
        Rails.logger.error error.backtrace.join("\n")

        # Broadcast failure update to UI
        broadcast_update(ingestion)
      end
    end

    def perform(ingestion_id)
      ingestion = Scribe::Ingestion.find_by(id: ingestion_id)

      # Skip if ingestion not found or already completed
      return log_skip(ingestion_id, "not found") unless ingestion
      return log_skip(ingestion_id, "already completed") if ingestion.status == "completed"

      # Mark as processing with optimistic locking to prevent race conditions
      ingestion.with_lock do
        return if ingestion.status == "completed" # Double-check after acquiring lock

        ingestion.update!(status: "processing")
      end

      # Process the utterance through LLM
      process_utterance(ingestion)

    rescue StandardError => e
      handle_processing_error(ingestion, e)
      raise # Re-raise to trigger retry mechanism
    end

    private

    def process_utterance(ingestion)
      Rails.logger.info "Processing utterance for ingestion #{ingestion.id}"

      # Extract utterance text
      utterance_text = ingestion.raw_utterance

      if utterance_text.blank?
        mark_as_failed(ingestion, "No utterance text to process")
        return
      end

      # Call UtteranceParser for LLM classification
      parser = Scribe::UtteranceParser.new(utterance_text)
      result = parser.parse!

      # Update ingestion with successful result
      ingestion.update!(
        status: "completed",
        parsed_data: result.processed_data,
        confidence_score: result.confidence,
        model_used: result.model_used,
        tokens_used: result.tokens_used,
        error_message: nil
      )

      # Link to created event based on type
      case result.event_type
      when "workout"
        ingestion.update!(workout_id: result.event.id) if result.event
      when "ingestion"
        ingestion.update!(ingestion_event_id: result.event.id) if result.event
      when "sleep"
        ingestion.update!(sleep_event_id: result.event.id) if result.event
      end

      Rails.logger.info "Successfully processed ingestion #{ingestion.id}"

      # Broadcast success update to UI
      broadcast_update(ingestion)

    rescue Scribe::UtteranceParser::ParseError => e
      # Handle parser-specific errors
      mark_as_failed(ingestion, "Parser error: #{e.message}")
    rescue StandardError => e
      # Let other errors bubble up for retry
      raise
    end

    def handle_processing_error(ingestion, error)
      return unless ingestion

      Rails.logger.error "Error processing ingestion #{ingestion.id}: #{error.message}"
      Rails.logger.error error.backtrace&.first(10)&.join("\n")

      # Update status to indicate error (but not final failure yet)
      ingestion.update!(
        status: "error",
        error_message: "Processing error: #{error.message}"
      )

      # Broadcast error state to UI
      broadcast_update(ingestion)
    end

    def mark_as_failed(ingestion, message)
      ingestion.update!(
        status: "failed",
        error_message: message
      )

      Rails.logger.error "Ingestion #{ingestion.id} failed: #{message}"

      # Broadcast failure to UI
      broadcast_update(ingestion)
    end

    def broadcast_update(ingestion)
      ingestion.reload # Ensure associations are loaded

      # Broadcast Turbo Stream update to refresh the specific row in the dashboard
      Turbo::StreamsChannel.broadcast_replace_to(
        "scribe_dashboard",
        target: "ingestion_#{ingestion.id}",
        partial: "scribe/ingestions/table_row",
        locals: { ingestion: ingestion }
      )
    end

    def log_skip(ingestion_id, reason)
      Rails.logger.info "Skipping ingestion #{ingestion_id}: #{reason}"
    end
  end
end
