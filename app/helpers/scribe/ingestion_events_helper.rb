# frozen_string_literal: true

module Scribe
  module IngestionEventsHelper
    def type_icon(ingestion_type)
      case ingestion_type
      when "food" then "🍔"
      when "beverage" then "🥤"
      when "medication" then "💊"
      when "supplement" then "🧪"
      when "substance" then "🌿"
      else "❓"
      end
    end
  end
end
