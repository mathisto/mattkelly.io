# Scribe: Natural Language Queries - Future Enhancement

## Overview
This document outlines the future enhancement for Scribe to support natural language querying of workout and habit data, enabling conversational analytics and insights.

## Current State (v1)
- **Ingestion**: Natural language input → Structured data (via Claude)
- **Editing**: Manual correction of parsed data through UI
- **Viewing**: Table-based display of workouts and ingestions

## Future Enhancement: Query Interface

### User Stories
1. "How many times did I run this month?"
2. "What's my average water intake on workout days?"
3. "Show me my protein consumption trend over the last 30 days"
4. "Did I workout more in September or October?"
5. "What's my longest streak of consecutive workout days?"

### Technical Approach

#### Option A: Claude-Powered SQL Generation
**Pros:**
- Reuses existing Anthropic integration
- Flexible, handles complex queries
- Can provide conversational responses

**Cons:**
- API costs per query
- Latency (network round-trip)
- Potential SQL injection risks (needs careful prompting)

**Implementation:**
```ruby
# app/services/scribe/query_processor.rb
class Scribe::QueryProcessor
  def initialize(user_question)
    @question = user_question
  end
  
  def execute
    sql = generate_sql(@question)
    results = ActiveRecord::Base.connection.exec_query(sql)
    format_response(results)
  end
  
  private
  
  def generate_sql(question)
    # Send to Claude with schema context
    # Return safe, validated SQL
  end
end
```

#### Option B: Predefined Query Templates + NLU
**Pros:**
- No API cost per query
- Faster response time
- More predictable/secure

**Cons:**
- Limited to predefined patterns
- Requires intent classification layer
- Less flexible than Option A

**Implementation:**
```ruby
# app/services/scribe/query_matcher.rb
class Scribe::QueryMatcher
  PATTERNS = {
    count_activity: /how many.*(?<activity>\w+).*(?<timeframe>this|last)?\s*(?<period>week|month|year)?/i,
    average_metric: /average.*(?<metric>\w+).*(?<timeframe>this|last)?\s*(?<period>week|month|year)?/i,
    # ... more patterns
  }
end
```

#### Option C: Hybrid Approach (Recommended)
1. **Fast path**: Match common queries against templates (95% of use cases)
2. **Slow path**: Fall back to Claude for complex/novel queries
3. **Learning**: Log successful Claude queries → promote to templates

### Database Considerations

#### Query Optimization
```ruby
# Add indexes for common query patterns
add_index :scribe_workouts, [:user_id, :created_at]
add_index :scribe_workouts, [:user_id, :activity_type, :created_at]
add_index :scribe_workouts, [:user_id, :distance_meters], where: "distance_meters IS NOT NULL"
```

#### Materialized Views for Analytics
```sql
CREATE MATERIALIZED VIEW scribe_monthly_stats AS
SELECT 
  user_id,
  date_trunc('month', created_at) as month,
  count(*) as workout_count,
  sum(duration_seconds) as total_duration,
  sum(distance_meters) as total_distance
FROM scribe_workouts
GROUP BY user_id, date_trunc('month', created_at);

CREATE INDEX ON scribe_monthly_stats (user_id, month);
```

### UI/UX Design

#### Dashboard Query Widget
```
┌─────────────────────────────────────────┐
│  Ask about your habits...               │
│  ┌─────────────────────────────────────┐│
│  │ How many times did I run this month?││
│  └─────────────────────────────────────┘│
│                            [Ask] button  │
└─────────────────────────────────────────┘
```

#### Response Display
```
┌─────────────────────────────────────────┐
│  Question: How many times did I run     │
│  this month?                            │
│                                         │
│  Answer:                                │
│  You ran 12 times in October 2025,     │
│  totaling 45.3 km.                     │
│                                         │
│  [See Details] [Ask Follow-up]          │
└─────────────────────────────────────────┘
```

### Privacy & Security

#### Scope Limitations
- Queries must be scoped to current_user (never cross-user)
- SQL generation must use parameterized queries
- Rate limiting on query endpoint (prevent abuse)

#### Prompt Engineering for SQL Safety
```ruby
QUERY_SYSTEM_PROMPT = <<~PROMPT
  You are a SQL query generator for a habit tracking database.
  
  CRITICAL RULES:
  1. ONLY SELECT queries (no INSERT, UPDATE, DELETE, DROP)
  2. ALWAYS include WHERE user_id = ? in every query
  3. Use parameterized placeholders for all user input
  4. Only query tables: scribe_workouts, scribe_ingestions
  5. Return ONLY valid PostgreSQL SELECT statements
  
  Schema: ...
PROMPT
```

### Implementation Phases

#### Phase 1: Simple Aggregations (MVP)
- Count queries ("How many X?")
- Sum queries ("Total distance this month?")
- Average queries ("Average water intake?")
- Template-based (no Claude)

#### Phase 2: Trend Analysis
- Comparisons ("More in Sept or Oct?")
- Streaks ("Longest workout streak?")
- Growth/decline trends
- Introduce Claude for complex queries

#### Phase 3: Insights & Recommendations
- Correlations ("Do I drink more water on run days?")
- Anomaly detection ("You usually run 3x/week, but this week...")
- Goal tracking & projections

#### Phase 4: Conversational Follow-ups
- Multi-turn conversations
- Clarifying questions
- Context retention across queries

### Metrics to Track
- Query response time (p50, p95, p99)
- Template match rate (fast path hit rate)
- Claude API usage/cost per query
- User query patterns (most common questions)
- Query success rate

### Cost Estimation

#### Claude API (Haiku)
- Input: ~500 tokens (schema + question)
- Output: ~100 tokens (SQL query)
- Cost per query: ~$0.00065
- 100 queries/day: $0.065/day = ~$2/month

#### Mitigation
- Cache common queries (Redis)
- Promote to templates after N uses
- Use free template matching when possible

### Example Implementation Timeline
- Week 1: Database indexes + basic templates
- Week 2: Query matcher service + simple UI
- Week 3: Claude integration for complex queries
- Week 4: Caching layer + optimization
- Week 5: Testing, refinement, polish

## Open Questions
1. Should we store query history for each user?
2. Allow export of query results (CSV)?
3. Scheduled queries (e.g., weekly summaries)?
4. Voice input via Web Speech API?
5. Chart/graph visualization of query results?

## Related Enhancements
- **Export**: CSV/PDF export of workout data
- **Goals**: Set targets, track progress via queries
- **Reminders**: "You haven't logged water today"
- **Social**: Compare stats with friends (privacy-conscious)

---

**Status**: Future Enhancement (post-MVP)  
**Dependencies**: Core Scribe system (workouts, ingestions)  
**Priority**: Medium (nice-to-have, not critical path)  
**Estimated Effort**: 2-3 weeks for Phase 1-2
