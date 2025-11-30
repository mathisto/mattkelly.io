module Scribe
  class JournalEntriesController < ApplicationController
    before_action :set_journal_entry, only: [ :show, :edit, :update, :destroy ]

    def index
      @journal_entries = JournalEntry.recent.page(params[:page])
    end

    def show
    end

    def new
      @journal_entry = JournalEntry.new
    end

    def create
      @journal_entry = JournalEntry.new(journal_entry_params)
      @journal_entry.occurred_at ||= Time.current
      @journal_entry.confidence_score = 1.0

      if @journal_entry.save
        redirect_to scribe_dashboard_path, notice: "Journal entry created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @journal_entry.update(journal_entry_params)
        redirect_to scribe_dashboard_path, notice: "Journal entry updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @journal_entry.destroy
      respond_to do |format|
        format.html { redirect_to scribe_dashboard_path, notice: "Journal entry deleted." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.remove("ingestion_#{@journal_entry.ingestion.id}")
        }
      end
    end

    private

    def set_journal_entry
      @journal_entry = JournalEntry.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to scribe_dashboard_path, alert: "Journal entry not found"
    end

    def journal_entry_params
      params.require(:journal_entry).permit(:content, :occurred_at, :original_utterance)
    end
  end
end
