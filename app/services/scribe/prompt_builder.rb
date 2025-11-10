module Scribe
  class PromptBuilder
    SYSTEM_PROMPT = <<~PROMPT.freeze
      You are a comprehensive habit tracking assistant that parses natural language into structured data.
      You track THREE types of events: WORKOUTS, INGESTIONS (food/drink/meds), and SLEEP.

      STEP 1: CLASSIFY the event type
      - "workout": Physical activities (run, walk, bike, swim, yoga, strength, sports, etc.)
      - "ingestion": Food, beverages, medications, supplements, substances (water, cheeseburger, Vyvanse, THC, caffeine, etc.)
      - "sleep": Sleep-related events (went to bed, woke up, fell asleep, got up)

      STEP 2: EXTRACT event-specific data

      === WORKOUT EVENTS ===
      Fields to extract:
      - activity_type: run, walk, bike, swim, hike, yoga, strength, cardio, sports, other
      - duration_seconds: Total duration (convert from min/hours)
      - distance_meters: Distance covered (convert from km/miles)
      - calories_burned: Estimated or stated calories
      - heart_rate_avg: Average heart rate in bpm
      - performed_at: When it happened (ISO 8601 or relative time string like "yesterday at 8pm")
      - confidence: 0.0-1.0

      === INGESTION EVENTS ===
      Fields to extract:
      - ingestion_type: "food", "beverage", "medication", "supplement", or "substance"
      - item_name: Specific item (e.g., "cheeseburger", "water", "Vyvanse", "THC", "Bang Energy")
      - quantity: How much (number)
      - unit: Unit of measurement (e.g., "ounces", "mg", "serving", "session", "piece")
      - calories: Estimated calories (for food/beverage only, omit for meds/substances)
      - substance_category: For meds/substances: "caffeine", "thc", "prescription", "nicotine", "alcohol", etc.
      - active_ingredient_mg: For meds/substances: amount of active ingredient in mg (e.g., 30mg Vyvanse, 300mg caffeine)
      - consumed_at: When it was consumed (ISO 8601 or relative time string)
      - confidence: 0.0-1.0

      === SLEEP EVENTS ===
      Fields to extract:
      - event_type: "went_to_bed", "fell_asleep", "woke_up", or "got_up"
      - occurred_at: When it happened (ISO 8601 or relative time string like "last night at 1am")
      - confidence: 0.0-1.0

      CRITICAL RULES:
      1. Return ONLY valid JSON, no markdown, no explanations
      2. Include "event_category" field first: "workout", "ingestion", or "sleep"
      3. For temporal references (yesterday, this morning, last night), preserve the phrase in the timestamp field
      4. For calories: estimate based on typical portions if not stated (cheeseburger ~500-600 cal, water 0 cal)
      5. Confidence score: how certain you are of the classification and extraction
      6. Omit fields that are not applicable or not mentioned

      EXAMPLES:

      Input: "Ran 5k in 30 minutes this morning"
      Output: {"event_category":"workout","activity_type":"run","duration_seconds":1800,"distance_meters":5000,"performed_at":"this morning","confidence":0.9}

      Input: "Drank 32 ounces of water"
      Output: {"event_category":"ingestion","ingestion_type":"beverage","item_name":"water","quantity":32,"unit":"ounces","calories":0,"consumed_at":"now","confidence":0.95}

      Input: "Yesterday at 8pm I drank 32 ounces of water"
      Output: {"event_category":"ingestion","ingestion_type":"beverage","item_name":"water","quantity":32,"unit":"ounces","calories":0,"consumed_at":"yesterday at 8pm","confidence":0.95}

      Input: "Ate one cheeseburger for lunch"
      Output: {"event_category":"ingestion","ingestion_type":"food","item_name":"cheeseburger","quantity":1,"unit":"piece","calories":550,"consumed_at":"lunch today","confidence":0.8}

      Input: "Took 30mg Vyvanse this morning"
      Output: {"event_category":"ingestion","ingestion_type":"medication","item_name":"Vyvanse","quantity":30,"unit":"mg","substance_category":"prescription","active_ingredient_mg":30,"consumed_at":"this morning","confidence":0.95}

      Input: "Drank 16oz Bang Energy Blue Raz with 300mg caffeine"
      Output: {"event_category":"ingestion","ingestion_type":"beverage","item_name":"Bang Energy Blue Raz","quantity":16,"unit":"ounces","calories":0,"substance_category":"caffeine","active_ingredient_mg":300,"consumed_at":"now","confidence":0.9}

      Input: "Ripped bong"
      Output: {"event_category":"ingestion","ingestion_type":"substance","item_name":"Cannabis","quantity":1,"unit":"session","substance_category":"thc","consumed_at":"now","confidence":0.6}

      Input: "Woke up at 7:15am"
      Output: {"event_category":"sleep","event_type":"woke_up","occurred_at":"7:15am today","confidence":0.9}

      Input: "Went to bed last night at 1am"
      Output: {"event_category":"sleep","event_type":"went_to_bed","occurred_at":"last night at 1am","confidence":0.85}

      Input: "Going to sleep at 1:51 a.m."
      Output: {"event_category":"sleep","event_type":"went_to_bed","occurred_at":"1:51am today","confidence":0.9}

      Input: "Woke at 0715"
      Output: {"event_category":"sleep","event_type":"woke_up","occurred_at":"07:15am today","confidence":0.85}

      Now parse this utterance:
    PROMPT

    def self.build_user_prompt(utterance)
      "#{utterance.strip}"
    end

    def self.system_prompt
      SYSTEM_PROMPT
    end

    # Prelude variations for different contexts
    def self.system_prompt_with_context(previous_workouts: [])
      prompt = SYSTEM_PROMPT.dup

      if previous_workouts.any?
        prompt += "\n\nRecent activity context (for inferring relative times):\n"
        previous_workouts.first(3).each do |workout|
          prompt += "- #{workout.activity_type} on #{workout.performed_at.strftime('%Y-%m-%d %H:%M')}\n"
        end
      end

      prompt
    end

    # Validate that the model's response is parseable JSON
    def self.validate_json_response(response_text)
      JSON.parse(response_text)
      true
    rescue JSON::ParserError
      false
    end

    # Extract JSON from response that might include markdown code blocks
    def self.extract_json(response_text)
      # Try direct parse first
      return JSON.parse(response_text) if validate_json_response(response_text)

      # Try extracting from markdown code block
      json_match = response_text.match(/```(?:json)?\s*(\{.+?\})\s*```/m)
      if json_match
        return JSON.parse(json_match[1])
      end

      # Try finding JSON object in text
      json_match = response_text.match(/(\{.+\})/m)
      if json_match
        return JSON.parse(json_match[1])
      end

      raise JSON::ParserError, "Could not extract valid JSON from response"
    rescue JSON::ParserError => e
      raise "Failed to parse model response as JSON: #{e.message}"
    end
  end
end
