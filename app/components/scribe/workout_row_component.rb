# TODO: Add Lookbook preview for Scribe::WorkoutRowComponent
module Scribe
  class WorkoutRowComponent < ApplicationComponent
    def initialize(workout:, **options)
      @workout = workout
      @options = options
    end

    def call
      content_tag(:tr, id: dom_id(@workout), class: row_classes, data: { controller: "edit-row" }) do
        safe_join([
          activity_cell,
          metrics_cell,
          timestamp_cell,
          confidence_cell,
          actions_cell
        ])
      end
    end

    private

    def row_classes
      base = "border-b border-[#3b4261] hover:bg-[#24283b] transition-colors"
      base += " bg-[#e0af68] bg-opacity-10" if @workout.needs_review?
      class_names(base, @options[:class])
    end

    def activity_cell
      content_tag(:td, class: "px-4 py-3") do
        safe_join([
          content_tag(:div, class: "font-medium text-[#c0caf5]") do
            @workout.activity_type.titleize
          end,
          @workout.original_utterance ? content_tag(:div, class: "text-xs text-[#565f89] mt-1") do
            truncate(@workout.original_utterance, length: 50)
          end : nil
        ].compact)
      end
    end

    def metrics_cell
      content_tag(:td, class: "px-4 py-3 text-sm text-[#a9b1d6]") do
        metrics = []
        metrics << "#{@workout.formatted_duration}" if @workout.duration_seconds
        metrics << "#{@workout.formatted_distance}" if @workout.distance_meters
        metrics << "#{@workout.calories_burned} cal" if @workout.calories_burned
        metrics << "#{@workout.formatted_water}" if @workout.water_ml
        metrics << "#{@workout.protein_grams}g protein" if @workout.protein_grams

        safe_join(metrics.map { |m| content_tag(:div, m) })
      end
    end

    def timestamp_cell
      content_tag(:td, class: "px-4 py-3 text-sm") do
        content_tag(:span,
                    "#{time_ago_in_words(@workout.performed_at)} ago",
                    class: "text-[#565f89] hover:text-[#7aa2f7] transition-colors cursor-help",
                    title: @workout.performed_at.in_time_zone("Eastern Time (US & Canada)").strftime("%Y-%m-%d %H:%M:%S %Z"))
      end
    end

    def confidence_cell
      content_tag(:td, class: "px-4 py-3") do
        if @workout.confidence_score
          render Scribe::BadgeComponent.new(
            text: "#{(@workout.confidence_score * 100).round}%",
            color: @workout.confidence_badge_color
          )
        else
          content_tag(:span, "—", class: "text-[#565f89]")
        end
      end
    end

    def actions_cell
      content_tag(:td, class: "px-4 py-3") do
        content_tag(:div, class: "flex items-center gap-2") do
          safe_join([
            review_button,
            edit_button,
            delete_button
          ].compact)
        end
      end
    end

    def review_button
      return unless @workout.needs_review?

      button_to mark_reviewed_scribe_workout_path(@workout),
                method: :patch,
                class: "text-[#9ece6a] hover:text-[#7dcfff] text-sm",
                title: "Mark as reviewed",
                data: { turbo_method: :patch } do
        "✓ Review"
      end
    end

    def edit_button
      link_to "Edit",
              edit_scribe_workout_path(@workout),
              class: "text-[#7aa2f7] hover:text-[#7dcfff] text-sm",
              data: { turbo_frame: "workout_#{@workout.id}" }
    end

    def delete_button
      button_to "Delete",
                scribe_workout_path(@workout),
                method: :delete,
                class: "text-[#f7768e] hover:text-[#ff9e9e] text-sm",
                data: {
                  turbo_method: :delete,
                  turbo_confirm: "Delete this workout?"
                }
    end
  end
end
