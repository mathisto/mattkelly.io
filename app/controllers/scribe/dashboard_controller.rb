module Scribe
  class DashboardController < ApplicationController
    def show
      # All ingestions for the activity log
      @q = Scribe::Ingestion.includes(:workout, :ingestion_event, :sleep_event, :journal_entry).ransack(params[:q])
      @q.sorts = "created_at desc" if @q.sorts.empty?
      @ingestions = @q.result.limit(100)

      # Load all stats using the StatsService
      stats = Scribe::StatsService.calculate_all_stats

      # Workouts for the workouts tab
      @workouts = Scribe::Workout.recent.limit(50)
      @workout_stats = stats[:workout_stats]

      # Ingestion events for the ingestion tab
      @ingestion_events = Scribe::IngestionEvent.recent.limit(50)
      @ingestion_stats = stats[:ingestion_stats]

      # Sleep events for the sleep tab
      @sleep_events = Scribe::SleepEvent.recent.limit(50)
      @sleep_stats = stats[:sleep_stats]

      # Journal entries for the journal tab
      @journal_entries = Scribe::JournalEntry.recent.limit(50)
      @journal_stats = stats[:journal_stats]

      # Set default tab
      @active_tab = params[:tab] || "all"
    end
  end
end
