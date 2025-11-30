# Scribe Multi-Event System Implementation

**Status:** Phase 1 & 2 Complete (Data + Service Layer) ✅  
**Current Phase:** Phase 3 (UI Layer) 🚧  
**Last Updated:** 2025-11-03

---

## Overview

Expanded Scribe from workout-only tracking to a comprehensive habit tracking system supporting:
- **Workouts** (physical activities)
- **Ingestions** (food, beverages, medications, supplements, substances)
- **Sleep** (sleep/wake event tracking with auto-pairing)

---

## ✅ COMPLETED - Phase 1: Data Layer

### Database Migrations

#### `scribe_ingestion_events`
Tracks all consumables (food, drink, meds, substances):
- **Classification:** `ingestion_type` (food, beverage, medication, supplement, substance)
- **Item tracking:** `item_name`, `quantity`, `unit`
- **Normalization:** `normalized_quantity`, `normalized_unit` (auto-converted to metric)
- **Nutritional:** `calories`, `protein_grams`, `carbs_grams`, `fat_grams`
- **Substances:** `substance_category`, `active_ingredient_mg`
- **Temporal:** `consumed_at` (supports retroactive entries)
- **Metadata:** `confidence_score`, `needs_review`, `notes`

#### `scribe_sleep_events`
Tracks sleep/wake events with automatic pairing:
- **Event types:** went_to_bed, fell_asleep, woke_up, got_up
- **Pairing:** `paired_sleep_event_id` (auto-links wake events to sleep events)
- **Duration:** `duration_minutes` (auto-calculated from paired events)
- **Quality:** `quality_score` (future feature for sleep quality tracking)
- **Temporal:** `occurred_at` (supports retroactive entries)

#### `scribe_ingestions` (Updated)
Polymorphic associations to link parsing records to any event type:
- `workout_id` (existing)
- `ingestion_event_id` (new)
- `sleep_event_id` (new)

### Models

#### `Scribe::IngestionEvent`
**Key Features:**
- Validations for all ingestion types
- Scopes: `food`, `beverage`, `medication`, `supplement`, `substance`, `today`, `this_week`
- Formatting: `formatted_quantity`, `formatted_normalized_quantity`, `formatted_calories`
- Icons: 🍔 (food), 🥤 (beverage), 💊 (medication), 🧪 (supplement), 🌿 (substance)
- Auto-review flagging for low confidence (<0.7)
- Summary generation for display

#### `Scribe::SleepEvent`
**Key Features:**
- Validations for sleep event types
- **Auto-pairing logic:** `try_pair_with_sleep_event` callback automatically links wake events to most recent unpaired sleep event
- **Duration calculation:** Automatically calculates sleep duration when paired
- Scopes: `went_to_bed`, `woke_up`, `today`, `this_week`
- Formatting: `formatted_duration` (e.g., "7h 24m")
- Icons: 🛏️ (sleep), ☀️ (wake)
- Helper methods: `sleep_event?`, `wake_event?`

#### `Scribe::Ingestion` (Updated)
**Key Features:**
- Polymorphic associations to all event types
- `parsed_event` - Returns workout, ingestion_event, or sleep_event
- `event_type` - Determines which type of event was created
- `parsed_summary` - Unified summary display for all types
- Separate summary methods: `workout_summary`, `ingestion_summary`, `sleep_summary`

---

## ✅ COMPLETED - Phase 2: Service Layer

### `Scribe::UnitNormalizer`
**Purpose:** Convert all units to standardized metric units

**Supported Conversions:**
- **Volume → ml:** oz, cups, pints, quarts, gallons, liters
- **Weight → g:** oz, lb, kg, mg
- **Medication → mg:** g, mcg, µg
- **Distance → m:** km, miles, feet, yards

**Context-Aware:** Automatically selects conversion based on ingestion type
- Beverages → volume (ml)
- Food → weight (g)
- Medications → mg
- General → auto-detect from unit

**Usage:**
```ruby
UnitNormalizer.normalize(32, "ounces", context: :volume)
# => { quantity: 946.35, unit: "ml" }
```

### `Scribe::TemporalParser`
**Purpose:** Parse relative time expressions into absolute timestamps

**Supported Patterns:**
- **Relative days:** "yesterday", "today", "tomorrow", "last night", "this morning", "X days ago"
- **Time formats:** "7am", "8:30pm", "0715" (military), "at 1:51 a.m."
- **Combined:** "yesterday at 8pm", "this morning at 7:15"

**Smart Logic:**
- Early morning times (before 6am) may refer to previous day if currently morning
- "last night at 1am" → yesterday 1am if spoken in morning
- "at 1am" → today or tomorrow based on current time

**Usage:**
```ruby
TemporalParser.parse("yesterday at 8pm")
# => 2025-11-02 20:00:00 (if today is Nov 3)

TemporalParser.confidence_for("yesterday at 8pm")
# => 0.95 (high confidence)
```

### `Scribe::PromptBuilder` (Updated)
**Purpose:** Generate Claude prompts for multi-event classification

**New System Prompt:**
- **Step 1:** Classify event as "workout", "ingestion", or "sleep"
- **Step 2:** Extract event-specific fields
- Includes comprehensive examples for all event types
- Returns `event_category` to route to correct parser

**Workout Fields:**
- activity_type, duration_seconds, distance_meters, calories_burned, heart_rate_avg, performed_at

**Ingestion Fields:**
- ingestion_type, item_name, quantity, unit, calories, substance_category, active_ingredient_mg, consumed_at

**Sleep Fields:**
- event_type, occurred_at

### `Scribe::UtteranceParser` (Updated)
**Purpose:** Parse utterances and create appropriate event type

**New Flow:**
1. Create `Ingestion` record (parsing record)
2. Call Claude with new multi-event prompt
3. Parse JSON response with `event_category`
4. **Route to correct creator:**
   - `create_workout(parsed_data)` - For physical activities
   - `create_ingestion_event(parsed_data)` - For consumables (uses UnitNormalizer)
   - `create_sleep_event(parsed_data)` - For sleep tracking
5. Link `Ingestion` to created event (polymorphic)
6. Use `TemporalParser` for all timestamps
7. Return `OpenStruct` with event, event_type, confidence

**Error Handling:**
- Graceful failures with `mark_failed!`
- Returns error message in result
- Original utterance preserved for debugging

---

## ✅ COMPLETED - Phase 2.5: Controller Updates

### `Scribe::DashboardController` (Updated)
**Changes:**
- Load `@ingestion_events` for new Ingestion tab
- Load `@sleep_events` for new Sleep tab
- Include all associations in `@ingestions` query (workout, ingestion_event, sleep_event)

---

## 🚧 IN PROGRESS - Phase 3: UI Layer

### Dashboard Tabs (Pending)
**Need to add 2 new tabs:**
```
[All Activity] [Workouts] [Ingestion] [Sleep] [Parse History]
```

**Tab Content:**
- **Ingestion Tab:** Display ingestion_events with icons, quantities, calories
- **Sleep Tab:** Display sleep events with duration, pairing indicators

### Table Row Components (Pending)

#### `Scribe::IngestionEventRowComponent`
**Display Requirements:**
- Icon based on ingestion_type (🍔🥤💊🌿)
- Item name + formatted quantity
- Calories (if applicable)
- Active ingredient (for meds/substances)
- Timestamp with retroactive support
- Confidence badge
- Actions: Edit, Delete, Review (if needed)

#### `Scribe::SleepEventRowComponent`
**Display Requirements:**
- Icon based on event_type (🛏️☀️)
- Event type (went to bed / woke up)
- Duration (if paired) - "slept 7h 24m"
- Timestamp
- Pairing indicator (linked to sleep/wake event)
- Confidence badge
- Actions: Edit, Delete

### Updated "parsed as" Display (Pending)
Current display only handles workouts. Need to update for all types:

**Workout:**
```
parsed as: walk • 6.6 km • 50m 0s
```

**Ingestion:**
```
parsed as: water • 946 ml • 0 kcal
parsed as: cheeseburger • 1 piece • 550 kcal
parsed as: Vyvanse • 30mg • prescription
```

**Sleep:**
```
parsed as: woke up • slept 7h 24m (if paired)
parsed as: went to bed (waiting for wake event)
```

**Failed Parse:**
```
❌ Parsing Error: Unable to extract structured data
```

### Controllers (Optional - Low Priority)

#### `Scribe::IngestionEventsController`
- CRUD actions for manual ingestion management
- Edit: Useful for correcting calories, quantities
- Delete: Remove incorrect entries
- Mark as reviewed: Clear review flag

#### `Scribe::SleepEventsController`
- CRUD actions for manual sleep management
- Edit: Correct times, manually pair/unpair events
- Delete: Remove incorrect entries

---

## 🎯 Next Steps (Priority Order)

### Immediate (High Priority)
1. ✅ **Update dashboard view** - Add Ingestion and Sleep tabs to UI
2. ✅ **Create IngestionEventRowComponent** - Display ingestion events in table
3. ✅ **Create SleepEventRowComponent** - Display sleep events in table
4. ✅ **Update table_row partial** - Handle all three event types in "parsed as" display
5. ✅ **Test end-to-end** - Submit sample utterances and verify:
   - Parsing works for all types
   - Events created correctly
   - Timestamps parsed correctly
   - Units normalized
   - Sleep pairing works

### Soon (Medium Priority)
6. **Add routes** - For ingestion_events and sleep_events controllers
7. **Error display improvements** - Red text for failed parses in table
8. **Add utility CSS classes** - Support new UI elements (icons, badges)
9. **Manual edit forms** - Allow correcting parsed events
10. **Stats widgets** - Dashboard summary cards:
    - Water goal tracker (ml/day)
    - Calorie totals
    - Sleep hours (last night, weekly average)

### Later (Low Priority)
11. **Data migration script** - Move existing "other" workouts with water_ml to ingestion_events
12. **RSpec tests** - Test new models, services, parsing logic
13. **User customization** - Personal food library (custom calorie values)
14. **Nutrition API integration** - Precise calorie lookup (Nutritionix, USDA)
15. **Insights dashboard** - Correlations, patterns, recommendations

---

## 📊 Testing Plan

### Unit Tests Needed
```ruby
# Models
describe Scribe::IngestionEvent
  - validates ingestion_type
  - normalizes quantities correctly
  - formats display correctly
  - confidence-based review flagging

describe Scribe::SleepEvent
  - validates event_type
  - auto-pairs with previous sleep event
  - calculates duration correctly
  - handles unpaired events gracefully

# Services
describe Scribe::UnitNormalizer
  - converts all volume units to ml
  - converts all weight units to g
  - converts all medication units to mg
  - handles unknown units gracefully

describe Scribe::TemporalParser
  - parses "yesterday at 8pm"
  - parses "this morning"
  - parses "last night at 1am"
  - handles military time (0715)
  - handles ambiguous times

describe Scribe::UtteranceParser
  - routes to correct event type
  - creates workout for physical activities
  - creates ingestion_event for consumables
  - creates sleep_event for sleep tracking
  - links ingestion to created event
  - handles parsing failures gracefully
```

### Integration Tests Needed
```ruby
# End-to-end flow
"Drank 32 ounces of water" →
  - Calls Claude
  - Parses as ingestion event
  - Creates IngestionEvent record
  - Normalizes 32oz → 946ml
  - Links Ingestion record
  - Displays in dashboard

"Woke up at 7:15am" →
  - Calls Claude  
  - Parses as sleep event
  - Creates SleepEvent record
  - Finds previous sleep event
  - Pairs and calculates duration
  - Displays with duration
```

### Manual Testing Checklist
- [ ] Submit workout utterance → creates Workout
- [ ] Submit water utterance → creates IngestionEvent (beverage)
- [ ] Submit food utterance → creates IngestionEvent (food) with estimated calories
- [ ] Submit medication utterance → creates IngestionEvent (medication)
- [ ] Submit substance utterance → creates IngestionEvent (substance)
- [ ] Submit sleep utterance → creates SleepEvent (went_to_bed)
- [ ] Submit wake utterance → creates SleepEvent (woke_up) and pairs with sleep
- [ ] Retroactive timestamp works ("yesterday at 8pm")
- [ ] "parsed as" displays correctly for all types
- [ ] Failed parse shows error message
- [ ] Dashboard tabs switch correctly
- [ ] Table displays all event types

---

## 🔧 Technical Decisions

### Why Separate Tables?
- **Distinct schemas:** Workouts need duration/distance, ingestions need calories/quantity, sleep needs pairing
- **Clean queries:** `IngestionEvent.beverage` vs complex WHERE clauses
- **Better validation:** Type-specific validations per model
- **Future extensibility:** Easy to add new event types without bloating single table

### Why Polymorphic Associations?
- Preserve existing `scribe_ingestions` table (parsing records)
- One parsing record can link to any event type
- Enables unified "All Activity" view
- Maintains audit trail of what was parsed

### Why Auto-Pairing for Sleep?
- User convenience: Don't make users manually link events
- Intelligent: Finds most recent unpaired sleep event
- Automatic duration: Calculates sleep time without user input
- Handles edge cases: Works with missing/unpaired events

### Why Unit Normalization?
- **Consistency:** All volumes in ml, weights in g, meds in mg
- **Easy calculations:** Sum daily water intake (all in ml)
- **Display flexibility:** Show user-friendly units (L for large volumes)
- **API ready:** Standardized units for future nutrition API integration

### Why Temporal Parsing?
- **Natural language:** Users say "yesterday at 8pm" not timestamps
- **Retroactive logging:** Common use case (forgot to log earlier)
- **Context-aware:** "last night at 1am" intelligently determines date
- **High confidence:** Explicit times get high confidence scores

---

## 📝 API Examples (For Future Reference)

### Creating Events Programmatically

```ruby
# Workout
Scribe::Workout.create!(
  activity_type: "run",
  distance_meters: 10000,
  duration_seconds: 3000,
  performed_at: Time.current,
  confidence_score: 0.95
)

# Ingestion Event (Water)
Scribe::IngestionEvent.create!(
  ingestion_type: "beverage",
  item_name: "water",
  quantity: 32,
  unit: "ounces",
  normalized_quantity: 946,
  normalized_unit: "ml",
  calories: 0,
  consumed_at: Time.current,
  confidence_score: 0.95
)

# Ingestion Event (Medication)
Scribe::IngestionEvent.create!(
  ingestion_type: "medication",
  item_name: "Vyvanse",
  quantity: 30,
  unit: "mg",
  normalized_quantity: 30,
  normalized_unit: "mg",
  substance_category: "prescription",
  active_ingredient_mg: 30,
  consumed_at: Time.current,
  confidence_score: 0.95
)

# Sleep Event
Scribe::SleepEvent.create!(
  event_type: "woke_up",
  occurred_at: Time.current,
  confidence_score: 0.9
)
# Auto-pairs with most recent unpaired sleep event
```

### Parsing Utterances

```ruby
parser = Scribe::UtteranceParser.new("Drank 32 ounces of water")
result = parser.parse!

if result.success
  puts "Created #{result.event_type}: #{result.event.inspect}"
  puts "Confidence: #{result.confidence}"
else
  puts "Error: #{result.error}"
end
```

---

## 🐛 Known Issues / Future Improvements

1. **Calorie estimation accuracy** - Currently Claude-based, consider nutrition API
2. **Substance dosage estimation** - "Ripped bong" has no way to estimate dosage accurately
3. **Sleep quality tracking** - Schema supports it but not parsed yet
4. **Multiple items in one utterance** - "Ate cheeseburger and fries" parses but may miss items
5. **Temporal ambiguity** - "at 1am" could be tonight or last night, uses heuristics
6. **Food customization** - No user library yet for custom calorie values

---

## 📚 Resources

- [Tim Pope Git Commit Style](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- [Rails 8 Guide](https://guides.rubyonrails.org)
- [Anthropic Claude API](https://docs.anthropic.com)

---

## 🎉 Summary

**What we built:**
- Multi-event tracking system (workouts, ingestions, sleep)
- Intelligent parsing with event classification
- Unit normalization (all units → metric)
- Temporal parsing (natural language → timestamps)
- Sleep auto-pairing with duration calculation
- Comprehensive data model with proper associations

**Current state:**
- ✅ Backend fully functional
- ✅ Parsing service complete
- ✅ Models with all features
- 🚧 UI needs completion (tabs, components, display)

**Ready for:**
- Testing the parsing in Rails console
- Building out the UI layer
- End-to-end integration testing
