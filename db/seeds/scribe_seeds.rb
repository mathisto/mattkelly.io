# Scribe Seeds - Sample workout data for testing
puts "\n🏃 Seeding Scribe data..."

# Create sample workouts
workouts_data = [
  {
    activity_type: "run",
    duration_seconds: 1800,
    distance_meters: 5000,
    calories_burned: 400,
    heart_rate_avg: 150,
    confidence_score: 0.95,
    original_utterance: "Ran 5k in 30 minutes this morning",
    performed_at: 1.day.ago,
    needs_review: false
  },
  {
    activity_type: "walk",
    duration_seconds: 3600,
    distance_meters: 4000,
    confidence_score: 0.88,
    original_utterance: "Walked 4km today, felt great",
    performed_at: 2.days.ago,
    needs_review: false
  },
  {
    activity_type: "other",
    water_ml: 2000,
    confidence_score: 0.92,
    original_utterance: "Drank 2 liters of water",
    performed_at: 3.hours.ago,
    needs_review: false
  },
  {
    activity_type: "yoga",
    duration_seconds: 2700,
    confidence_score: 0.65,
    original_utterance: "45 min yoga session",
    performed_at: 1.week.ago,
    needs_review: true  # Low confidence
  },
  {
    activity_type: "strength",
    duration_seconds: 3600,
    calories_burned: 300,
    protein_grams: 30,
    confidence_score: 0.78,
    original_utterance: "1 hour strength training, protein shake after",
    performed_at: 3.days.ago,
    needs_review: false
  }
]

workouts_data.each do |data|
  Scribe::Workout.create!(data)
  print "."
end

# Create sample ingestions
ingestions_data = [
  {
    raw_utterance: "Ran 5k in 30 minutes this morning",
    status: "completed",
    confidence_score: 0.95,
    model_used: Scribe::Ingestion::MODEL_HAIKU,
    tokens_used: 450,
    parsed_data: { activity_type: "run", duration_seconds: 1800, distance_meters: 5000 },
    workout: Scribe::Workout.first
  },
  {
    raw_utterance: "Did some complicated workout with intervals and stuff",
    status: "completed",
    confidence_score: 0.72,
    model_used: Scribe::Ingestion::MODEL_SONNET,
    tokens_used: 820,
    parsed_data: { activity_type: "cardio", duration_seconds: 2400 }
  },
  {
    raw_utterance: "asdf jkl; qwerty",
    status: "failed",
    error_message: "Could not parse utterance - no recognizable activity",
    model_used: Scribe::Ingestion::MODEL_HAIKU,
    tokens_used: 200
  }
]

ingestions_data.each do |data|
  Scribe::Ingestion.create!(data)
  print "."
end

puts "\n✅ Created #{Scribe::Workout.count} workouts and #{Scribe::Ingestion.count} ingestions"
puts "   - #{Scribe::Workout.needs_review.count} workouts need review"
puts "   - #{Scribe::Ingestion.failed.count} failed ingestions"
