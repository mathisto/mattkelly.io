require "ostruct"

module Scribe
  class UtteranceParser
    attr_reader :ingestion, :utterance

    def initialize(utterance)
      @utterance = utterance.strip
      @ingestion = nil
    end

    # Main entry point - parse utterance and create appropriate event
    def parse!
      # Create ingestion record
      @ingestion = Ingestion.create!(
        raw_utterance: @utterance,
        status: "pending"
      )

      # Mark as processing
      @ingestion.mark_processing!

      # Check for keyword short-circuit FIRST
      keyword_result = try_keyword_shortcut
      return keyword_result if keyword_result

      # No keyword match - proceed with LLM classification
      # Determine which model to use
      model = select_model
      @ingestion.update!(model_used: model)

      # Send to Claude
      response = send_to_claude(model)

      # Parse response
      parsed_data = extract_parsed_data(response[:content])

      # Create the appropriate event based on event_category
      event = create_event(parsed_data)

      # Link ingestion to the created event
      link_ingestion_to_event(event, parsed_data)

      # Mark ingestion as completed
      @ingestion.update!(
        status: "completed",
        confidence_score: parsed_data["confidence"] || 0.5,
        tokens_used: response[:usage][:total_tokens]
      )

      OpenStruct.new(
        success: true,
        event: event,
        event_type: parsed_data["event_category"],
        ingestion: @ingestion,
        confidence: parsed_data["confidence"]
      )
    rescue StandardError => e
      @ingestion&.mark_failed!(e.message)

      OpenStruct.new(
        success: false,
        error: e.message,
        ingestion: @ingestion
      )
    end

    private

    # Keyword-based short-circuit logic
    KEYWORD_MAPPINGS = {
      "journal" => :journal,
      "workout" => :workout,
      "ingestion" => :ingestion,
      "sleep" => :sleep
    }.freeze

    def try_keyword_shortcut
      # Extract first word (case-insensitive)
      first_word = @utterance.split.first&.downcase
      return nil unless first_word

      # Check if first word matches a keyword
      event_type = KEYWORD_MAPPINGS[first_word]
      return nil unless event_type

      # Extract the rest of the utterance (everything after the keyword)
      remaining_text = @utterance.split[1..].join(" ").strip

      Rails.logger.info "[UtteranceParser] Keyword shortcut detected: #{first_word} -> #{event_type}"

      # Create event directly based on keyword
      event = case event_type
      when :journal
                create_journal_entry(remaining_text)
      when :workout, :ingestion, :sleep
                # For these types, we still need LLM but we can pass the hint
                return nil # Let LLM handle it for now
      else
                return nil
      end

      # Link ingestion to event
      @ingestion.update!(
        journal_entry: event,
        status: "completed",
        confidence_score: 1.0, # Perfect confidence for keyword-based
        model_used: "keyword-shortcut"
      )

      OpenStruct.new(
        success: true,
        event: event,
        event_type: "journal",
        ingestion: @ingestion,
        confidence: 1.0
      )
    rescue StandardError => e
      Rails.logger.error "[UtteranceParser] Keyword shortcut failed: #{e.message}"
      nil # Fall back to LLM processing
    end

    def create_journal_entry(content)
      JournalEntryCreator.new(
        content: content,
        occurred_at: Time.current
      ).create!
    end

    def select_model
      # Simple heuristic: use Sonnet for complex utterances
      complexity = calculate_complexity

      if complexity > 50
        Ingestion::MODEL_SONNET
      else
        Ingestion::MODEL_HAIKU
      end
    end

    def calculate_complexity
      # Length of utterance
      length_score = @utterance.length / 10.0

      # Number of numeric values (indicates multiple data points)
      number_count = @utterance.scan(/\d+/).count

      # Number of commas/conjunctions (indicates multiple activities)
      conjunction_count = @utterance.scan(/\band\b|\bwith\b|,/).count

      length_score + (number_count * 5) + (conjunction_count * 10)
    end

    def send_to_claude(model)
      client = AnthropicClient.new

      # Get system prompt (could include context in future)
      system_prompt = PromptBuilder.system_prompt

      # Build user prompt
      user_prompt = PromptBuilder.build_user_prompt(@utterance)

      # Send to API
      client.send_message(
        prompt: user_prompt,
        system_prompt: system_prompt,
        model: model,
        max_tokens: 1024,
        temperature: 0.3
      )
    end

    def extract_parsed_data(response_content)
      PromptBuilder.extract_json(response_content)
    rescue StandardError => e
      raise "Failed to extract structured data from Claude response: #{e.message}"
    end

    def create_event(parsed_data)
      event_category = parsed_data["event_category"]

      case event_category
      when "workout"
        create_workout(parsed_data)
      when "ingestion"
        create_ingestion_event(parsed_data)
      when "sleep"
        create_sleep_event(parsed_data)
      else
        # Default to workout with "other" type for backward compatibility
        create_workout(parsed_data.merge("activity_type" => "other"))
      end
    end

    def create_workout(parsed_data)
      workout_attrs = {
        activity_type: parsed_data["activity_type"] || "other",
        duration_seconds: parsed_data["duration_seconds"],
        distance_meters: parsed_data["distance_meters"],
        calories_burned: parsed_data["calories_burned"],
        heart_rate_avg: parsed_data["heart_rate_avg"],
        performed_at: parse_timestamp(parsed_data["performed_at"]),
        confidence_score: parsed_data["confidence"],
        original_utterance: @utterance
      }

      workout_attrs.compact!
      Workout.create!(workout_attrs)
    end

    def create_ingestion_event(parsed_data)
      # Normalize units
      normalized = UnitNormalizer.normalize(
        parsed_data["quantity"],
        parsed_data["unit"],
        context: ingestion_context(parsed_data["ingestion_type"])
      )

      ingestion_attrs = {
        ingestion_type: parsed_data["ingestion_type"] || "other",
        item_name: parsed_data["item_name"] || "Unknown",
        quantity: parsed_data["quantity"],
        unit: parsed_data["unit"],
        normalized_quantity: normalized[:quantity],
        normalized_unit: normalized[:unit],
        calories: parsed_data["calories"],
        protein_grams: parsed_data["protein_grams"],
        carbs_grams: parsed_data["carbs_grams"],
        fat_grams: parsed_data["fat_grams"],
        substance_category: parsed_data["substance_category"],
        active_ingredient_mg: parsed_data["active_ingredient_mg"],
        consumed_at: parse_timestamp(parsed_data["consumed_at"]),
        confidence_score: parsed_data["confidence"],
        original_utterance: @utterance,
        notes: parsed_data["notes"]
      }

      ingestion_attrs.compact!
      IngestionEvent.create!(ingestion_attrs)
    end

    def create_sleep_event(parsed_data)
      sleep_attrs = {
        event_type: parsed_data["event_type"] || "woke_up",
        occurred_at: parse_timestamp(parsed_data["occurred_at"]),
        confidence_score: parsed_data["confidence"],
        original_utterance: @utterance,
        notes: parsed_data["notes"]
      }

      sleep_attrs.compact!
      SleepEvent.create!(sleep_attrs)
    end

    def link_ingestion_to_event(event, parsed_data)
      case parsed_data["event_category"]
      when "workout"
        @ingestion.update!(workout: event)
      when "ingestion"
        @ingestion.update!(ingestion_event: event)
      when "sleep"
        @ingestion.update!(sleep_event: event)
      when "journal"
        @ingestion.update!(journal_entry: event)
      end
    end

    def ingestion_context(ingestion_type)
      case ingestion_type
      when "beverage" then :volume
      when "food" then :weight
      when "medication", "supplement", "substance" then :medication
      else :general
      end
    end

    def parse_timestamp(timestamp_str)
      return Time.current unless timestamp_str.present?

      # Try parsing as ISO 8601 first
      begin
        return Time.zone.parse(timestamp_str) if timestamp_str =~ /^\d{4}-\d{2}-\d{2}/
      rescue ArgumentError
        # Fall through to temporal parser
      end

      # Use temporal parser for relative times
      TemporalParser.parse(timestamp_str)
    end
  end
end
