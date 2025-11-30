# frozen_string_literal: true

module Scribe
  module FormattingHelper
    def formatted_duration(duration_in_seconds)
      return nil unless duration_in_seconds

      hours = duration_in_seconds / 3600
      minutes = (duration_in_seconds % 3600) / 60
      seconds = duration_in_seconds % 60

      if hours > 0
        "#{hours}h #{minutes}m"
      elsif minutes > 0
        "#{minutes}m #{seconds}s"
      else
        "#{seconds}s"
      end
    end

    def formatted_duration_minutes(duration_in_minutes)
      return nil unless duration_in_minutes

      hours = duration_in_minutes / 60
      minutes = duration_in_minutes % 60

      if hours > 0
        "#{hours}h #{minutes}m"
      else
        "#{minutes}m"
      end
    end

    def formatted_distance(distance_in_meters)
      return nil unless distance_in_meters

      if distance_in_meters >= 1000
        "#{(distance_in_meters / 1000.0).round(2)} km"
      else
        "#{distance_in_meters} m"
      end
    end

    def formatted_water(water_in_ml)
      return nil unless water_in_ml

      if water_in_ml >= 1000
        "#{(water_in_ml / 1000.0).round(2)} L"
      else
        "#{water_in_ml} ml"
      end
    end

    def formatted_weight(weight_in_grams)
      return nil unless weight_in_grams

      "#{(weight_in_grams / 1000.0).round(2)} kg"
    end

    def confidence_badge_color(confidence_score)
      return "gray" unless confidence_score

      if confidence_score >= 0.9
        "green"
      elsif confidence_score >= 0.7
        "blue"
      elsif confidence_score >= 0.5
        "yellow"
      else
        "red"
      end
    end

    def workout_summary(workout)
      parts = []

      if workout.distance_meters.present?
        parts << formatted_distance(workout.distance_meters)
      end

      if workout.duration_seconds.present?
        parts << "in #{formatted_duration(workout.duration_seconds)}"
      end

      if workout.calories_burned.present? && workout.distance_meters.blank?
        parts << "#{workout.calories_burned} cal"
      end

      if workout.water_ml.present?
        parts << formatted_water(workout.water_ml)
      end

      if workout.protein_grams.present?
        parts << "#{workout.protein_grams}g protein"
      end

      if workout.weight_grams.present?
        parts << formatted_weight(workout.weight_grams)
      end

      if workout.heart_rate_avg.present?
        parts << "#{workout.heart_rate_avg} bpm avg"
      end

      parts.any? ? parts.join(", ") : "—"
    end

    def formatted_quantity(quantity, unit)
      return nil unless quantity && unit

      "#{quantity} #{unit}"
    end

    def formatted_normalized_quantity(normalized_quantity, normalized_unit)
      return nil unless normalized_quantity && normalized_unit

      case normalized_unit
      when "ml"
        if normalized_quantity >= 1000
          "#{(normalized_quantity / 1000.0).round(2)} L"
        else
          "#{normalized_quantity.round(0)} ml"
        end
      when "mg"
        if normalized_quantity >= 1000
          "#{(normalized_quantity / 1000.0).round(2)} g"
        else
          "#{normalized_quantity.round(0)} mg"
        end
      when "g"
        if normalized_quantity >= 1000
          "#{(normalized_quantity / 1000.0).round(2)} kg"
        else
          "#{normalized_quantity.round(0)} g"
        end
      else
        "#{normalized_quantity.round(2)} #{normalized_unit}"
      end
    end

    def formatted_calories(calories)
      return nil unless calories

      "#{calories} kcal"
    end

    def ingestion_event_summary(ingestion_event)
      parts = []
      parts << ingestion_event.item_name
      parts << formatted_normalized_quantity(ingestion_event.normalized_quantity, ingestion_event.normalized_unit) if ingestion_event.normalized_quantity
      parts << formatted_calories(ingestion_event.calories) if ingestion_event.calories
      parts << "#{ingestion_event.active_ingredient_mg}mg #{ingestion_event.substance_category}" if ingestion_event.active_ingredient_mg && ingestion_event.substance_category
      parts.join(" • ")
    end
  end
end
