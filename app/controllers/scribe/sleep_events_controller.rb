# frozen_string_literal: true

module Scribe
  class SleepEventsController < ApplicationController
    before_action :set_sleep_event, only: %i[show edit update destroy]

    # GET /scribe/sleep_events
    def index
      @sleep_events = Scribe::SleepEvent
                      .order(occurred_at: :desc)
                      .limit(100)
    end

    # GET /scribe/sleep_events/:id
    def show
      # @sleep_event is set by before_action
      # View can access pairing info via @sleep_event.paired_sleep_event
    end

    # GET /scribe/sleep_events/new
    def new
      @sleep_event = Scribe::SleepEvent.new
    end

    # POST /scribe/sleep_events
    def create
      @sleep_event = Scribe::SleepEvent.new(sleep_event_params)

      if @sleep_event.save
        # Trigger auto-pairing for wake events
        @sleep_event.pair_with_previous_sleep! if @sleep_event.event_type == "wake"

        redirect_to scribe_dashboard_path(tab: "sleep"),
                    notice: "Sleep event created successfully"
      else
        flash.now[:alert] = "Failed to create sleep event"
        render :new, status: :unprocessable_entity
      end
    end

    # GET /scribe/sleep_events/:id/edit
    def edit
      # @sleep_event is set by before_action
    end

    # PATCH/PUT /scribe/sleep_events/:id
    def update
      if @sleep_event.update(sleep_event_params)
        # Re-trigger pairing logic for wake events
        @sleep_event.pair_with_previous_sleep! if @sleep_event.event_type == "wake"

        redirect_to scribe_dashboard_path(tab: "sleep"),
                    notice: "Sleep event updated successfully"
      else
        flash.now[:alert] = "Failed to update sleep event"
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /scribe/sleep_events/:id
    def destroy
      # If this event was paired, unpair its mate
      if @sleep_event.paired_sleep_event.present?
        @sleep_event.paired_sleep_event.update(paired_sleep_event_id: nil)
      end

      @sleep_event.destroy
      redirect_to scribe_dashboard_path(tab: "sleep"),
                  notice: "Sleep event deleted successfully"
    end

    private

    def set_sleep_event
      @sleep_event = Scribe::SleepEvent.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to scribe_dashboard_path(tab: "sleep"),
                  alert: "Sleep event not found"
    end

    def sleep_event_params
      params.expect(sleep_event: [ :event_type, :occurred_at, :notes ])
    end
  end
end
