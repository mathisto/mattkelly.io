module Scribe
  class SleepEvent < ::ApplicationRecord
    self.table_name = "scribe_sleep_events"

    # Associations
    has_one :ingestion, class_name: "Scribe::Ingestion", foreign_key: :sleep_event_id, dependent: :nullify
    belongs_to :paired_sleep_event, class_name: "Scribe::SleepEvent", optional: true
    has_one :paired_wake_event, class_name: "Scribe::SleepEvent", foreign_key: :paired_sleep_event_id, dependent: :nullify

    # Validations
    validates :event_type, presence: true, inclusion: { in: %w[went_to_bed fell_asleep woke_up got_up] }
    validates :occurred_at, presence: true
    validates :confidence_score, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true }
    validates :duration_minutes, numericality: { greater_than: 0, allow_nil: true }
    validates :quality_score, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true }

    # Scopes
    scope :recent, -> { order(occurred_at: :desc) }
    scope :needs_review, -> { where(needs_review: true) }
    scope :by_type, ->(type) { where(event_type: type) }
    scope :went_to_bed, -> { where(event_type: "went_to_bed") }
    scope :woke_up, -> { where(event_type: "woke_up") }
    scope :today, -> { where("date(occurred_at) = date(?)", Time.current) }
    scope :this_week, -> { where("occurred_at >= ?", 1.week.ago) }
    scope :this_month, -> { where("occurred_at >= ?", 1.month.ago) }

    # Event type constants
    EVENT_TYPES = %w[went_to_bed fell_asleep woke_up got_up].freeze

    # Confidence threshold for auto-review flagging
    CONFIDENCE_THRESHOLD = 0.7

    # Callbacks
    before_save :check_confidence_threshold
    after_save :try_pair_with_sleep_event

    def self.ransackable_attributes(auth_object = nil)
      %w[event_type occurred_at duration_minutes quality_score needs_review confidence_score created_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[ingestion paired_sleep_event]
    end

    # Formatted display methods
    def formatted_duration
      return nil unless duration_minutes

      hours = duration_minutes / 60
      minutes = duration_minutes % 60

      if hours > 0
        "#{hours}h #{minutes}m"
      else
        "#{minutes}m"
      end
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

    # Generate icon for event type
    def type_icon
      case event_type
      when "went_to_bed", "fell_asleep" then "🛏️"
      when "woke_up", "got_up" then "☀️"
      else "❓"
      end
    end

    # Check if this is a sleep event (went_to_bed or fell_asleep)
    def sleep_event?
      %w[went_to_bed fell_asleep].include?(event_type)
    end

    # Check if this is a wake event (woke_up or got_up)
    def wake_event?
      %w[woke_up got_up].include?(event_type)
    end

    # Find the most recent unpaired sleep event before this wake event
    def find_unpaired_sleep_event
      return nil unless wake_event?

      SleepEvent
        .where(event_type: %w[went_to_bed fell_asleep])
        .where("occurred_at < ?", occurred_at)
        .where(paired_sleep_event_id: nil) # Not already paired
        .order(occurred_at: :desc)
        .first
    end

    # Calculate and set duration based on paired event
    def calculate_duration!
      return unless wake_event? && paired_sleep_event

      minutes = ((occurred_at - paired_sleep_event.occurred_at) / 60).round
      update_column(:duration_minutes, minutes) if minutes > 0
    end

    def mark_as_reviewed!
      update!(needs_review: false)
    end

    private

    def check_confidence_threshold
      if confidence_score.present? && confidence_score < CONFIDENCE_THRESHOLD
        self.needs_review = true
      end
    end

    # Automatically pair wake events with the most recent sleep event
    def try_pair_with_sleep_event
      return unless wake_event? && paired_sleep_event_id.nil?

      SleepEvent.transaction do
        sleep_event = find_unpaired_sleep_event
        if sleep_event
          sleep_event.lock! # Pessimistic locking to prevent race conditions
          update!(paired_sleep_event_id: sleep_event.id)
          calculate_duration!
        end
      end
    end
  end
end
