# Scribe Setup Instructions

## Quick Setup

### 1. Add Anthropic API Key

Edit `.env` file in the project root and add:

```bash
# Anthropic Claude API for Scribe habit tracking
ANTHROPIC_API_KEY=sk-ant-api03-YOUR_ACTUAL_KEY_HERE
```

**Get your API key**: https://console.anthropic.com/settings/keys

### 2. Restart Rails Server

```bash
# Stop current server (Ctrl+C or kill the process)
# Then restart:
bin/dev
# or
bin/rails server
```

### 3. Test Scribe

Visit: **http://localhost:8080/scribe**

Try submitting:
- "Ran 5k in 30 minutes"
- "Drank 2 liters of water"
- "Weight: 70kg, feeling great"

## Environment Variables

Scribe requires the following environment variables in `.env`:

| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | Yes | Claude API key from Anthropic Console |

## Troubleshooting

### Error: "ANTHROPIC_API_KEY not set"

**Problem**: Rails can't find your API key

**Solutions**:
1. Check `.env` file has the key (no quotes needed)
2. Restart Rails server after adding the key
3. Ensure `dotenv-rails` gem is installed (it is)
4. Check for typos in the key

### Error: "uninitialized constant OpenStruct"

**Problem**: Missing Ruby standard library require

**Solution**: This has been fixed in the code. If you still see it:
```bash
git pull  # Get latest changes
```

### Error: 401 Unauthorized from Anthropic

**Problem**: Invalid API key

**Solutions**:
1. Verify key is correct (starts with `sk-ant-api03-`)
2. Check key hasn't been revoked in Anthropic Console
3. Ensure no extra spaces in `.env` file

### Workouts Not Appearing

**Problem**: Parsing succeeds but no workout created

**Solutions**:
1. Check Rails console: `Scribe::Workout.count`
2. Check ingestion status: `Scribe::Ingestion.last.status`
3. Look for error messages in `Scribe::Ingestion.last.error_message`

## API Usage & Costs

### Model Selection

Scribe automatically chooses the right model:

- **Haiku** (fast, cheap): Simple utterances
  - Example: "Ran 5k"
  - Cost: ~$0.0009 per parse

- **Sonnet** (complex): Multi-metric utterances
  - Example: "Ran 5k in 30 min with 150 avg HR and drank 500ml water"
  - Cost: ~$0.0030 per parse

### Monthly Cost Estimate

Based on 100 parses/month (90% Haiku, 10% Sonnet):
- **Total**: ~$0.11/month
- **Extremely affordable** for personal use

## Development Tips

### Testing Without API Calls

Create workouts directly in Rails console:

```ruby
Scribe::Workout.create!(
  activity_type: "run",
  duration_seconds: 1800,
  distance_meters: 5000,
  confidence_score: 1.0,
  original_utterance: "Manual test workout",
  performed_at: Time.current
)
```

### Checking Ingestion History

```ruby
# View all ingestions
Scribe::Ingestion.all

# Check last ingestion
last = Scribe::Ingestion.last
puts "Status: #{last.status}"
puts "Model: #{last.model_used}"
puts "Error: #{last.error_message}" if last.failed?
puts "Parsed: #{last.parsed_data}"
```

### Manual Parsing Test

```ruby
parser = Scribe::UtteranceParser.new("Ran 5k in 30 minutes")
result = parser.parse!

if result.success
  puts "Success! Workout ID: #{result.workout.id}"
  puts "Confidence: #{result.confidence}"
else
  puts "Error: #{result.error}"
end
```

## Features

### Keyboard Shortcuts

- **Ctrl+Enter** (or Cmd+Enter): Submit utterance
- **Autofocus**: Textarea is focused on page load

### Confidence Scoring

- **< 70%**: Automatically flagged for review (yellow badge)
- **70-90%**: Medium confidence (blue badge)
- **> 90%**: High confidence (green badge)

### Activity Types

Supported activities:
- run, walk, bike, swim, hike
- yoga, strength, cardio
- sports, other

### Metrics Tracked

- Duration (seconds)
- Distance (meters)
- Calories burned
- Heart rate (average)
- Water intake (milliliters)
- Protein (grams)
- Body weight (grams)

All automatically converted from natural language!

## Next Steps

1. Add your API key to `.env`
2. Restart server
3. Visit `/scribe` and test
4. Track your first workout!
5. Review the dashboard stats
6. Check ingestion history

---

**Documentation**: `/docs/planning/scribe-implementation-complete.md`  
**Future Features**: `/docs/planning/scribe-natural-language-queries.md`
