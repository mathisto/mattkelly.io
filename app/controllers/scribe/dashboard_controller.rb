module Scribe
  class DashboardController < ApplicationController
  def show
    # All ingestions for the activity log
    @q = Scribe::Ingestion.includes(:workout, :ingestion_event, :sleep_event, :journal_entry).ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @ingestions = @q.result.limit(100)

    # Workouts for the workouts tab
    @workouts = Scribe::Workout.recent.limit(50)
    @workout_stats = calculate_workout_stats

    # Ingestion events for the ingestion tab
    @ingestion_events = Scribe::IngestionEvent.recent.limit(50)
    @ingestion_stats = calculate_ingestion_stats

    # Sleep events for the sleep tab
    @sleep_events = Scribe::SleepEvent.recent.limit(50)
    @sleep_stats = calculate_sleep_stats

    # Journal entries for the journal tab
    @journal_entries = Scribe::JournalEntry.recent.limit(50)
    @journal_stats = calculate_journal_stats

    # Set default tab
    @active_tab = params[:tab] || "all"
  end

  private

  def calculate_workout_stats
    {
      today: workout_rollup(Scribe::Workout.today),
      week: workout_rollup(Scribe::Workout.this_week),
      month: workout_rollup(Scribe::Workout.this_month)
    }
  end

  def workout_rollup(scope)
    {
      count: scope.count,
      total_duration: scope.sum(:duration_seconds),
      total_distance: scope.sum(:distance_meters),
      total_calories: scope.sum(:calories_burned),
      activities: scope.group(:activity_type).count
    }
  end

  def calculate_ingestion_stats
    {
      today: ingestion_rollup(Scribe::IngestionEvent.today),
      week: ingestion_rollup(Scribe::IngestionEvent.this_week),
      month: ingestion_rollup(Scribe::IngestionEvent.this_month)
    }
  end

  def ingestion_rollup(scope)
    {
      count: scope.count,
      total_calories: scope.sum(:calories),
      by_type: scope.group(:ingestion_type).count
    }
  end

  def calculate_sleep_stats
    {
      today: sleep_rollup(Scribe::SleepEvent.today),
      week: sleep_rollup(Scribe::SleepEvent.this_week),
      month: sleep_rollup(Scribe::SleepEvent.this_month)
    }
  end

  def sleep_rollup(scope)
    wake_events = scope.where(event_type: %w[woke_up got_up])
    {
      count: wake_events.count,
      total_duration: wake_events.sum(:duration_minutes),
      avg_duration: wake_events.average(:duration_minutes)&.round(1),
      avg_quality: wake_events.average(:quality_score)&.round(2)
    }
  end

  def calculate_journal_stats
    {
      today: journal_rollup(Scribe::JournalEntry.where("DATE(occurred_at) = DATE(?)", Time.current)),
      week: journal_rollup(Scribe::JournalEntry.where("occurred_at >= ?", 1.week.ago)),
      month: journal_rollup(Scribe::JournalEntry.where("occurred_at >= ?", 1.month.ago))
    }
  end

  def journal_rollup(scope)
    {
      count: scope.count,
      total_words: scope.sum("LENGTH(content) - LENGTH(REPLACE(content, ' ', '')) + 1")
    }
  end
  end
end
