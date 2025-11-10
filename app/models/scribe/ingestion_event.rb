module Scribe
  class IngestionEvent < ::ApplicationRecord
    self.table_name = "scribe_ingestion_events"

    # Associations
    has_one :ingestion, class_name: "Scribe::Ingestion", foreign_key: :ingestion_event_id, dependent: :nullify

    # Validations
    validates :ingestion_type, presence: true, inclusion: { in: %w[food beverage medication supplement substance] }
    validates :item_name, presence: true
    validates :consumed_at, presence: true
    validates :confidence_score, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true }
    validates :quantity, numericality: { greater_than: 0, allow_nil: true }
    validates :normalized_quantity, numericality: { greater_than: 0, allow_nil: true }
    validates :calories, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
    validates :active_ingredient_mg, numericality: { greater_than: 0, allow_nil: true }

    # Scopes
    scope :recent, -> { order(consumed_at: :desc) }
    scope :needs_review, -> { where(needs_review: true) }
    scope :by_type, ->(type) { where(ingestion_type: type) }
    scope :food, -> { where(ingestion_type: "food") }
    scope :beverage, -> { where(ingestion_type: "beverage") }
    scope :medication, -> { where(ingestion_type: "medication") }
    scope :supplement, -> { where(ingestion_type: "supplement") }
    scope :substance, -> { where(ingestion_type: "substance") }
    scope :today, -> { where("date(consumed_at) = date(?)", Time.current) }
    scope :this_week, -> { where("consumed_at >= ?", 1.week.ago) }
    scope :this_month, -> { where("consumed_at >= ?", 1.month.ago) }

    # Ingestion type constants
    INGESTION_TYPES = %w[food beverage medication supplement substance].freeze

    # Substance category constants
    SUBSTANCE_CATEGORIES = %w[caffeine thc prescription nicotine alcohol stimulant depressant other].freeze

    # Confidence threshold for auto-review flagging
    CONFIDENCE_THRESHOLD = 0.7

    # Callbacks
    before_save :check_confidence_threshold

    def self.ransackable_attributes(auth_object = nil)
      %w[ingestion_type item_name quantity unit consumed_at calories substance_category needs_review confidence_score created_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[ingestion]
    end

    # Formatted display methods
    def formatted_quantity
      return nil unless quantity && unit

      "#{quantity} #{unit}"
    end

    def formatted_normalized_quantity
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

    def formatted_calories
      return nil unless calories

      "#{calories} kcal"
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

    # Generate icon for ingestion type
    def type_icon
      case ingestion_type
      when "food" then "🍔"
      when "beverage" then "🥤"
      when "medication" then "💊"
      when "supplement" then "🧪"
      when "substance" then "🌿"
      else "❓"
      end
    end

    # Generate a summary for display
    def summary
      parts = []
      parts << item_name
      parts << formatted_normalized_quantity if formatted_normalized_quantity
      parts << formatted_calories if calories
      parts << "#{active_ingredient_mg}mg #{substance_category}" if active_ingredient_mg && substance_category
      parts.join(" • ")
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
  end
end
