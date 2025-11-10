module Scribe
  class TemporalParser
    # Parse temporal expressions and return a DateTime
    # Examples: "yesterday at 8pm", "this morning at 7am", "last night at 1am"

    def self.parse(time_string, reference_time: Time.current)
      return reference_time if time_string.blank?

      time_string = time_string.to_s.downcase.strip

      # Try to extract relative day and time
      relative_day = extract_relative_day(time_string, reference_time)
      time_of_day = extract_time_of_day(time_string, reference_time)

      # Combine them
      if relative_day && time_of_day
        combine_date_and_time(relative_day, time_of_day)
      elsif time_of_day
        # Just a time, assume today or adjust based on logic
        adjust_time_for_today(time_of_day, reference_time)
      elsif relative_day
        # Just a day reference, use reference time
        relative_day
      else
        # Couldn't parse, return reference time
        reference_time
      end
    end

    private

    def self.extract_relative_day(text, reference_time)
      case text
      when /yesterday/
        reference_time.yesterday.beginning_of_day
      when /today/
        reference_time.beginning_of_day
      when /tomorrow/
        reference_time.tomorrow.beginning_of_day
      when /last night/
        # Last night means yesterday evening
        reference_time.yesterday.beginning_of_day
      when /this morning/
        reference_time.beginning_of_day
      when /this afternoon/
        reference_time.beginning_of_day
      when /this evening|tonight/
        reference_time.beginning_of_day
      when /(\d+)\s*(day|days)\s*ago/
        days_ago = $1.to_i
        reference_time.ago(days_ago.days).beginning_of_day
      else
        nil
      end
    end

    def self.extract_time_of_day(text, reference_time)
      # Match patterns like "at 7am", "at 8:30pm", "7:15", "1am", "12:00"

      # Pattern 1: HH:MM am/pm or HH am/pm
      if text =~ /(\d{1,2})(:(\d{2}))?\s*(am|pm|a\.m\.|p\.m\.)/i
        hour = $1.to_i
        minute = $3 ? $3.to_i : 0
        meridiem = $4.downcase.gsub(".", "")

        hour = 0 if hour == 12 && meridiem.start_with?("a")
        hour += 12 if hour != 12 && meridiem.start_with?("p")

        Time.zone.local(reference_time.year, reference_time.month, reference_time.day, hour, minute)

      # Pattern 2: Military time or just hour (HH:MM or HHMM)
      elsif text =~ /(\d{1,2}):(\d{2})/
        hour = $1.to_i
        minute = $2.to_i

        Time.zone.local(reference_time.year, reference_time.month, reference_time.day, hour, minute)

      # Pattern 3: Just a number with am/pm implied from context
      elsif text =~ /\b(\d{1,2})\s*(am|pm|a\.m\.|p\.m\.)/i
        hour = $1.to_i
        meridiem = $2.downcase.gsub(".", "")

        hour = 0 if hour == 12 && meridiem.start_with?("a")
        hour += 12 if hour != 12 && meridiem.start_with?("p")

        Time.zone.local(reference_time.year, reference_time.month, reference_time.day, hour, 0)

      # Pattern 4: HHMM format (e.g., "0715" for 7:15am)
      elsif text =~ /\b(\d{4})\b/
        time_str = $1
        hour = time_str[0..1].to_i
        minute = time_str[2..3].to_i

        Time.zone.local(reference_time.year, reference_time.month, reference_time.day, hour, minute)
      else
        nil
      end
    end

    def self.combine_date_and_time(date, time)
      Time.zone.local(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.min,
        time.sec
      )
    end

    def self.adjust_time_for_today(time_of_day, reference_time)
      # If the time is in the future, it's today
      # If the time is in the past and it's early morning, it might be "last night"
      # Use heuristics based on current time

      combined = Time.zone.local(
        reference_time.year,
        reference_time.month,
        reference_time.day,
        time_of_day.hour,
        time_of_day.min
      )

      # Special case: If it's early morning (before 6am) and we're currently in the morning,
      # the time might refer to "last night" (previous day)
      if combined.hour < 6 && reference_time.hour > 6
        combined - 1.day
      elsif combined > reference_time
        # Time is in the future, assume it's later today
        combined
      else
        # Time is in the past today
        combined
      end
    end

    # Helper to determine confidence level
    def self.confidence_for(time_string)
      return 0.5 if time_string.blank?

      text = time_string.to_s.downcase

      # High confidence: explicit date + time
      return 0.95 if text =~ /yesterday.*\d+.*[ap]m/ || text =~ /today.*\d+.*[ap]m/

      # Medium confidence: relative day or specific time
      return 0.8 if text =~ /yesterday|today|last night/ || text =~ /\d+.*[ap]m/

      # Low confidence: vague or inferred
      0.6
    end
  end
end
