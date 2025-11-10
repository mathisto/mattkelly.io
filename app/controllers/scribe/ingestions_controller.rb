module Scribe
  class IngestionsController < ApplicationController
    before_action :set_ingestion, only: [ :show, :retry, :edit, :update, :destroy ]

    def index
      @q = Ingestion.ransack(params[:q])
      @ingestions = @q.result.recent.page(params[:page])

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def show
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def edit
      # Just render the edit form
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def update
      old_utterance = @ingestion.raw_utterance

      if @ingestion.update(ingestion_params)
        # If utterance changed, re-parse it
        if @ingestion.raw_utterance != old_utterance
          @ingestion.update!(status: "pending", error_message: nil)
          Scribe::ProcessUtteranceJob.perform_later(@ingestion.id)
          notice = "Utterance updated. Re-parsing in background..."
        else
          notice = "Ingestion updated successfully."
        end

        respond_to do |format|
          format.html { redirect_to scribe_dashboard_path, notice: notice }
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("flash-message",
                partial: "scribe/utterances/form_processing"
              ),
              turbo_stream.replace("ingestion_#{@ingestion.id}",
                partial: "scribe/ingestions/table_row",
                locals: { ingestion: @ingestion.reload }
              )
            ]
          end
        end
      else
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("ingestion_form_#{@ingestion.id}",
              partial: "scribe/ingestions/form",
              locals: { ingestion: @ingestion }
            )
          end
        end
      end
    end

    def destroy
      @ingestion.destroy!

      respond_to do |format|
        format.html { redirect_to scribe_dashboard_path, notice: "Ingestion deleted successfully." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("ingestion_#{@ingestion.id}"),
            turbo_stream.update("flash-message",
              html: '<div class="text-[#9ece6a] p-4">Ingestion deleted successfully.</div>'
            )
          ]
        end
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to scribe_dashboard_path, alert: "Failed to delete: #{e.message}" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("flash-message",
            html: "<div class='text-[#f7768e] p-4'>Failed to delete: #{e.message}</div>"
          )
        end
      end
    end

    def retry
      if @ingestion.retryable?
        # Reset status to pending and enqueue background job
        @ingestion.update!(status: "pending", error_message: nil)
        ProcessUtteranceJob.perform_later(@ingestion.id)

        respond_to do |format|
          format.html { redirect_to scribe_dashboard_path, notice: "Retrying in background..." }
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update("flash-message",
                partial: "scribe/utterances/form_processing"
              ),
              turbo_stream.replace("ingestion_#{@ingestion.id}",
                partial: "scribe/ingestions/table_row",
                locals: { ingestion: @ingestion.reload }
              )
            ]
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to scribe_dashboard_path, alert: "Ingestion cannot be retried." }
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("flash-message",
              html: '<div class="text-[#f7768e]">Cannot retry this ingestion.</div>'
            )
          end
        end
      end
    end

    private

    def set_ingestion
      @ingestion = Ingestion.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to scribe_dashboard_path, alert: "Ingestion not found"
    end

    def ingestion_params
      params.expect(ingestion: [ :raw_utterance ])
    end
  end
end
