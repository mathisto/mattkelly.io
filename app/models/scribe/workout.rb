module Scribe
  class Workout < ::ApplicationRecord
    self.table_name = "scribe_workouts"

    # Associations
    has_one :ingestion, class_name: "Scribe::Ingestion", foreign_key: :workout_id, dependent: :nullify

    # Validations
    validates :activity_type, presence: true
    validates :confidence_score, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true }
    validates :duration_seconds, numericality: { greater_than: 0, allow_nil: true }
    validates :distance_meters, numericality: { greater_than: 0, allow_nil: true }
    validates :calories_burned, numericality: { greater_than: 0, allow_nil: true }
    validates :heart_rate_avg, numericality: { greater_than: 0, allow_nil: true }
    validates :water_ml, numericality: { greater_than: 0, allow_nil: true }
    validates :protein_grams, numericality: { greater_than: 0, allow_nil: true }
    validates :weight_grams, numericality: { greater_than: 0, allow_nil: true }

    # Scopes
    scope :needs_review, -> { where(needs_review: true) }
    scope :reviewed, -> { where(needs_review: false) }
    scope :recent, -> { order(performed_at: :desc) }
    scope :by_activity, ->(type) { where(activity_type: type) }
    scope :low_confidence, -> { where("confidence_score < ?", 0.7) }
    scope :high_confidence, -> { where("confidence_score >= ?", 0.7) }
    scope :today, -> { where("date(performed_at) = date(?)", Time.current) }
    scope :this_week, -> { where("performed_at >= ?", 1.week.ago) }
    scope :this_month, -> { where("performed_at >= ?", 1.month.ago) }

    # Callbacks
    before_validation :set_performed_at_default
    before_save :check_confidence_threshold

    # Activity type constants
    ACTIVITY_TYPES = %w[
      run walk bike swim hike yoga strength cardio sports other
    ].freeze

    # Confidence threshold for auto-review flagging
    CONFIDENCE_THRESHOLD = 0.7

    def self.ransackable_attributes(auth_object = nil)
      %w[activity_type duration_seconds distance_meters calories_burned water_ml
         protein_grams weight_grams performed_at needs_review confidence_score created_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[ingestion]
    end

    # Helper methods
    def formatted_duration
      return nil unless duration_seconds

      hours = duration_seconds / 3600
      minutes = (duration_seconds % 3600) / 60
      seconds = duration_seconds % 60

      if hours > 0
        "#{hours}h #{minutes}m"
      elsif minutes > 0
        "#{minutes}m #{seconds}s"
      else
        "#{seconds}s"
      end
    end

    def formatted_distance
      return nil unless distance_meters

      if distance_meters >= 1000
        "#{(distance_meters / 1000.0).round(2)} km"
      else
        "#{distance_meters} m"
      end
    end

    def formatted_water
      return nil unless water_ml

      if water_ml >= 1000
        "#{(water_ml / 1000.0).round(2)} L"
      else
        "#{water_ml} ml"
      end
    end

    def formatted_weight
      return nil unless weight_grams

      "#{(weight_grams / 1000.0).round(2)} kg"
    end

    def confidence_badge_color
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

    def mark_as_reviewed!
      update!(needs_review: false)
    end

    # Generate a human-readable summary of the workout details
    def summary
      parts = []

      # Distance activities (run, walk, bike, swim, hike)
      if distance_meters.present?
        parts << formatted_distance
      end

      # Duration
      if duration_seconds.present?
        parts << "in #{formatted_duration}"
      end

      # Calories
      if calories_burned.present? && distance_meters.blank?
        parts << "#{calories_burned} cal"
      end

      # Water
      if water_ml.present?
        parts << formatted_water
      end

      # Protein
      if protein_grams.present?
        parts << "#{protein_grams}g protein"
      end

      # Weight tracking
      if weight_grams.present?
        parts << formatted_weight
      end

      # Heart rate
      if heart_rate_avg.present?
        parts << "#{heart_rate_avg} bpm avg"
      end

      parts.any? ? parts.join(", ") : "—"
    end

    private

    def set_performed_at_default
      self.performed_at ||= Time.current
    end

    def check_confidence_threshold
      if confidence_score.present? && confidence_score < CONFIDENCE_THRESHOLD
        self.needs_review = true
      end
    end
  end
end
