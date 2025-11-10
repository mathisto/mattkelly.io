module Scribe
  class UtterancesController < ApplicationController
    # POST /scribe/utterances
    def create
      utterance = params[:utterance]

      if utterance.blank?
        respond_to do |format|
          format.html { redirect_to scribe_dashboard_path, alert: "Utterance cannot be blank." }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("utterance_form", partial: "scribe/utterances/form_errors") }
        end
        return
      end

      # Check for API key
      if ENV["ANTHROPIC_API_KEY"].blank?
        respond_to do |format|
          format.html { redirect_to scribe_dashboard_path, alert: "Anthropic API key not configured. Please add ANTHROPIC_API_KEY to your .env file." }
          format.turbo_stream do
            flash.now[:alert] = "API key not configured. Add ANTHROPIC_API_KEY to .env and restart server."
          end
        end
        return
      end

      # Create ingestion record immediately with pending status
      ingestion = Ingestion.create!(
        raw_utterance: utterance,
        status: "pending"
      )

      # Enqueue background job to process the utterance
      Scribe::ProcessUtteranceJob.perform_later(ingestion.id)

      # Respond immediately with processing state
      respond_to do |format|
        format.html { redirect_to scribe_dashboard_path, notice: "Processing your workout entry..." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash-message",
              partial: "scribe/utterances/form_processing"
            ),
            turbo_stream.update("utterance_form",
              partial: "scribe/utterances/form"
            ),
            turbo_stream.prepend("ingestions-body",
              partial: "scribe/ingestions/table_row",
              locals: { ingestion: ingestion }
            )
          ]
        end
      end
    end
  end
end
