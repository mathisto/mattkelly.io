# frozen_string_literal: true

module Scribe
  class IngestionEventsController < ApplicationController
    before_action :set_ingestion_event, only: %i[show edit update destroy]

    # GET /scribe/ingestion_events
    def index
      @ingestion_events = Scribe::IngestionEvent
                            .order(consumed_at: :desc)
                            .limit(100)
    end

    # GET /scribe/ingestion_events/:id
    def show
    end

    # GET /scribe/ingestion_events/new
    def new
      @ingestion_event = Scribe::IngestionEvent.new
    end

    # POST /scribe/ingestion_events
    def create
      @ingestion_event = Scribe::IngestionEvent.new(ingestion_event_params)

      if @ingestion_event.save
        redirect_to scribe_dashboard_path(tab: "ingestions"),
                    notice: "Ingestion event created successfully"
      else
        flash.now[:alert] = "Failed to create ingestion event"
        render :new, status: :unprocessable_entity
      end
    end

    # GET /scribe/ingestion_events/:id/edit
    def edit
    end

    # PATCH/PUT /scribe/ingestion_events/:id
    def update
      if @ingestion_event.update(ingestion_event_params)
        redirect_to scribe_dashboard_path(tab: "ingestions"),
                    notice: "Ingestion event updated successfully"
      else
        flash.now[:alert] = "Failed to update ingestion event"
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /scribe/ingestion_events/:id
    def destroy
      @ingestion_event.destroy!
      redirect_to scribe_dashboard_path(tab: "ingestions"),
                  notice: "Ingestion event deleted successfully",
                  status: :see_other
    end

    private

    def set_ingestion_event
      @ingestion_event = Scribe::IngestionEvent.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to scribe_dashboard_path, alert: "Ingestion event not found"
    end

    def ingestion_event_params
      params.expect(ingestion_event: [
        :ingestion_type,
        :item_name,
        :quantity,
        :unit,
        :normalized_quantity,
        :normalized_unit,
        :calories,
        :protein_grams,
        :carbs_grams,
        :fat_grams,
        :substance_category,
        :active_ingredient_mg,
        :consumed_at,
        :original_utterance,
        :notes,
        :confidence_score,
        :needs_review
      ])
    end
  end
end
