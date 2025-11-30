module Scribe
  class UnitNormalizer
    # Convert various units to standardized metric units
    # Returns hash: { quantity: normalized_value, unit: normalized_unit }

    # Volume conversions (to milliliters)
    VOLUME_TO_ML = {
      "ml" => 1.0,
      "milliliter" => 1.0,
      "milliliters" => 1.0,
      "l" => 1000.0,
      "liter" => 1000.0,
      "liters" => 1000.0,
      "oz" => 29.5735,
      "ounce" => 29.5735,
      "ounces" => 29.5735,
      "fl oz" => 29.5735,
      "cup" => 236.588,
      "cups" => 236.588,
      "pint" => 473.176,
      "pints" => 473.176,
      "quart" => 946.353,
      "quarts" => 946.353,
      "gallon" => 3785.41,
      "gallons" => 3785.41
    }.freeze

    # Weight conversions (to grams)
    WEIGHT_TO_G = {
      "g" => 1.0,
      "gram" => 1.0,
      "grams" => 1.0,
      "kg" => 1000.0,
      "kilogram" => 1000.0,
      "kilograms" => 1000.0,
      "mg" => 0.001,
      "milligram" => 0.001,
      "milligrams" => 0.001,
      "oz" => 28.3495,
      "ounce" => 28.3495,
      "ounces" => 28.3495,
      "lb" => 453.592,
      "lbs" => 453.592,
      "pound" => 453.592,
      "pounds" => 453.592
    }.freeze

    # Medication/substance units (to milligrams)
    MEDICATION_TO_MG = {
      "mg" => 1.0,
      "milligram" => 1.0,
      "milligrams" => 1.0,
      "g" => 1000.0,
      "gram" => 1000.0,
      "grams" => 1000.0,
      "mcg" => 0.001,
      "microgram" => 0.001,
      "micrograms" => 0.001,
      "ug" => 0.001,
      "µg" => 0.001
    }.freeze

    # Distance conversions (to meters)
    DISTANCE_TO_M = {
      "m" => 1.0,
      "meter" => 1.0,
      "meters" => 1.0,
      "km" => 1000.0,
      "kilometer" => 1000.0,
      "kilometers" => 1000.0,
      "mi" => 1609.34,
      "mile" => 1609.34,
      "miles" => 1609.34,
      "ft" => 0.3048,
      "feet" => 0.3048,
      "foot" => 0.3048,
      "yd" => 0.9144,
      "yard" => 0.9144,
      "yards" => 0.9144
    }.freeze

    def self.normalize(quantity, unit, context: :general)
      return { quantity: nil, unit: nil } if quantity.nil? || unit.nil?

      quantity = quantity.to_f
      unit_lower = unit.to_s.downcase.strip

      case context
      when :volume, :liquid, :beverage
        normalize_volume(quantity, unit_lower)
      when :weight, :food
        normalize_weight(quantity, unit_lower)
      when :medication, :supplement, :substance
        normalize_medication(quantity, unit_lower)
      when :distance
        normalize_distance(quantity, unit_lower)
      else
        # Try to auto-detect category
        auto_normalize(quantity, unit_lower)
      end
    end

    def self.normalize_volume(quantity, unit)
      multiplier = VOLUME_TO_ML[unit]
      return { quantity: quantity, unit: unit } unless multiplier

      {
        quantity: (quantity * multiplier).round(2),
        unit: "ml"
      }
    end

    def self.normalize_weight(quantity, unit)
      multiplier = WEIGHT_TO_G[unit]
      return { quantity: quantity, unit: unit } unless multiplier

      {
        quantity: (quantity * multiplier).round(2),
        unit: "g"
      }
    end

    def self.normalize_medication(quantity, unit)
      multiplier = MEDICATION_TO_MG[unit]
      return { quantity: quantity, unit: unit } unless multiplier

      {
        quantity: (quantity * multiplier).round(2),
        unit: "mg"
      }
    end

    def self.normalize_distance(quantity, unit)
      multiplier = DISTANCE_TO_M[unit]
      return { quantity: quantity, unit: unit } unless multiplier

      {
        quantity: (quantity * multiplier).round(2),
        unit: "m"
      }
    end

    def self.auto_normalize(quantity, unit)
      # Try each category in order of likelihood
      if VOLUME_TO_ML.key?(unit)
        normalize_volume(quantity, unit)
      elsif MEDICATION_TO_MG.key?(unit)
        normalize_medication(quantity, unit)
      elsif WEIGHT_TO_G.key?(unit)
        normalize_weight(quantity, unit)
      elsif DISTANCE_TO_M.key?(unit)
        normalize_distance(quantity, unit)
      else
        # Unknown unit, return as-is
        { quantity: quantity, unit: unit }
      end
    end
  end
end
