# frozen_string_literal: true

module Scribe
  module SleepEventsHelper
    def type_icon(event_type)
      case event_type
      when "went_to_bed", "fell_asleep" then "🛏️"
      when "woke_up", "got_up" then "☀️"
      else "❓"
      end
    end
  end
end
