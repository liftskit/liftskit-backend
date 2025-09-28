# Analytics Backend Implementation Plan

## Overview
This document outlines the backend queries and data structures needed to implement comprehensive analytics for the LiftsKit app. The current system tracks basic exercise data, but with PostgreSQL, we can provide much more powerful and insightful analytics.

## Current Data Structure Analysis

### Existing Tables
- `workouts_performed` - Contains workout sessions with date, user_id, workout_id
- `exercises_performed` - Contains individual exercise data with weight, reps, sets, time, orm_percent
- `users` - User information and one-rep-max data
- `workouts` - Workout templates
- `exercises` - Exercise definitions

### Current Analytics Limitations
1. Only shows weight progression over time for individual exercises
2. No workout frequency analysis
3. No volume tracking (total weight lifted)
4. No strength progression metrics
5. No workout duration analysis
6. No program adherence tracking

## Proposed Analytics Features

### 1. Strength Progression Analytics

#### One-Rep-Max Tracking & Estimation
```sql
-- Calculate estimated 1RM for each exercise session
WITH estimated_orm AS (
  SELECT 
    ep.id,
    ep.name,
    ep.weight,
    ep.reps,
    ep.date,
    -- Epley formula: weight * (1 + reps/30)
    ep.weight * (1 + ep.reps::float / 30) as estimated_orm,
    -- Alternative: Brzycki formula: weight * (36 / (37 - reps))
    CASE 
      WHEN ep.reps < 37 THEN ep.weight * (36.0 / (37 - ep.reps))
      ELSE ep.weight
    END as brzycki_orm
  FROM exercises_performed ep
  WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
)
SELECT * FROM estimated_orm ORDER BY name, date;
```

#### Personal Records Tracking
```sql
-- Track personal records for each exercise
WITH exercise_maxes AS (
  SELECT 
    name,
    MAX(weight) as max_weight,
    MAX(estimated_orm) as max_estimated_orm,
    MAX(weight * reps) as max_volume
  FROM estimated_orm
  GROUP BY name
)
SELECT * FROM exercise_maxes ORDER BY max_estimated_orm DESC;
```

### 2. Volume & Load Analytics

#### Total Volume Tracking
```sql
-- Calculate total volume (weight * reps) per workout
SELECT 
  wp.id as workout_id,
  wp.date,
  wp.workout_name,
  SUM(ep.weight * ep.reps) as total_volume,
  COUNT(DISTINCT ep.name) as exercise_count,
  AVG(ep.weight * ep.reps) as avg_exercise_volume
FROM workouts_performed wp
JOIN exercises_performed ep ON wp.id = ep.workout_id
WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
GROUP BY wp.id, wp.date, wp.workout_name
ORDER BY wp.date DESC;
```

#### Weekly/Monthly Volume Trends
```sql
-- Weekly volume trends
SELECT 
  DATE_TRUNC('week', wp.date) as week_start,
  SUM(ep.weight * ep.reps) as weekly_volume,
  COUNT(DISTINCT wp.id) as workout_count,
  COUNT(DISTINCT ep.name) as unique_exercises
FROM workouts_performed wp
JOIN exercises_performed ep ON wp.id = ep.workout_id
WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
GROUP BY DATE_TRUNC('week', wp.date)
ORDER BY week_start DESC;
```

### 3. Workout Frequency & Consistency

#### Workout Frequency Analysis
```sql
-- Workout frequency by week/month
SELECT 
  DATE_TRUNC('week', date) as week_start,
  COUNT(*) as workouts_per_week,
  COUNT(DISTINCT workout_name) as unique_workouts,
  AVG(EXTRACT(EPOCH FROM (workout_time::time))) as avg_workout_duration_seconds
FROM workouts_performed
GROUP BY DATE_TRUNC('week', date)
ORDER BY week_start DESC;
```

#### Consistency Metrics
```sql
-- Calculate workout consistency (streak analysis)
WITH workout_dates AS (
  SELECT DISTINCT DATE(date) as workout_date
  FROM workouts_performed
  ORDER BY workout_date DESC
),
streaks AS (
  SELECT 
    workout_date,
    ROW_NUMBER() OVER (ORDER BY workout_date DESC) as row_num,
    workout_date - INTERVAL '1 day' * ROW_NUMBER() OVER (ORDER BY workout_date DESC) as group_date
  FROM workout_dates
)
SELECT 
  MIN(workout_date) as streak_start,
  MAX(workout_date) as streak_end,
  COUNT(*) as streak_length
FROM streaks
GROUP BY group_date
ORDER BY streak_length DESC;
```

### 4. Exercise-Specific Analytics

#### Exercise Frequency & Progression
```sql
-- Most frequently performed exercises with progression
SELECT 
  ep.name,
  COUNT(*) as total_sessions,
  MIN(ep.date) as first_performed,
  MAX(ep.date) as last_performed,
  AVG(ep.weight) as avg_weight,
  MAX(ep.weight) as max_weight,
  AVG(ep.weight * ep.reps) as avg_volume,
  MAX(ep.weight * ep.reps) as max_volume
FROM exercises_performed ep
WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
GROUP BY ep.name
HAVING COUNT(*) >= 3  -- Only exercises performed 3+ times
ORDER BY total_sessions DESC;
```

#### Exercise Difficulty Progression
```sql
-- Track how exercise difficulty (ORM percentage) changes over time
SELECT 
  ep.name,
  ep.date,
  ep.orm_percent,
  ep.weight,
  ep.reps,
  LAG(ep.orm_percent) OVER (PARTITION BY ep.name ORDER BY ep.date) as previous_orm_percent,
  ep.orm_percent - LAG(ep.orm_percent) OVER (PARTITION BY ep.name ORDER BY ep.date) as orm_change
FROM exercises_performed ep
WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
ORDER BY ep.name, ep.date;
```

### 5. Program Adherence & Effectiveness

#### Program Completion Rates
```sql
-- Track how often users complete planned workouts vs actual workouts
SELECT 
  wp.program_name,
  wp.workout_name,
  COUNT(*) as times_performed,
  AVG(EXTRACT(EPOCH FROM (wp.workout_time::time))) as avg_duration_seconds,
  COUNT(DISTINCT wp.date) as unique_dates
FROM workouts_performed wp
GROUP BY wp.program_name, wp.workout_name
ORDER BY times_performed DESC;
```

#### Superset Analysis
```sql
-- Analyze superset performance and rest patterns
SELECT 
  ep.name,
  ep.superset_group,
  ep.superset_order,
  AVG(ep.weight) as avg_weight,
  AVG(ep.reps) as avg_reps,
  COUNT(*) as superset_sessions
FROM exercises_performed ep
WHERE ep.is_superset = true
GROUP BY ep.name, ep.superset_group, ep.superset_order
ORDER BY ep.superset_group, ep.superset_order;
```

### 6. Cardio & Endurance Analytics

#### Cardio Performance Tracking
```sql
-- Cardio exercise analysis
SELECT 
  ep.name,
  ep.date,
  ep.time as duration_minutes,
  ep.weight as resistance_level,
  AVG(ep.time) OVER (PARTITION BY ep.name ORDER BY ep.date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) as avg_duration_5_sessions
FROM exercises_performed ep
WHERE ep._type = 'Cardio'
ORDER BY ep.name, ep.date;
```

### 7. Advanced Analytics Queries

#### Strength-to-Weight Ratio
```sql
-- Calculate strength relative to body weight (if body weight is tracked)
WITH user_stats AS (
  SELECT 
    u.id,
    u.weight as body_weight,
    AVG(ep.weight * ep.reps) as avg_volume
  FROM users u
  JOIN workouts_performed wp ON u.id = wp.user_id
  JOIN exercises_performed ep ON wp.id = ep.workout_id
  WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
  GROUP BY u.id, u.weight
)
SELECT 
  id,
  body_weight,
  avg_volume,
  avg_volume / body_weight as strength_to_weight_ratio
FROM user_stats;
```

#### Plateau Detection
```sql
-- Detect potential strength plateaus (no improvement in 4+ weeks)
WITH exercise_progression AS (
  SELECT 
    ep.name,
    ep.date,
    ep.weight,
    LAG(ep.weight, 1) OVER (PARTITION BY ep.name ORDER BY ep.date) as prev_weight,
    LAG(ep.weight, 2) OVER (PARTITION BY ep.name ORDER BY ep.date) as prev_weight_2,
    LAG(ep.weight, 3) OVER (PARTITION BY ep.name ORDER BY ep.date) as prev_weight_3
  FROM exercises_performed ep
  WHERE ep._type IN ('Strength', 'Weightlifting', 'Weights')
)
SELECT 
  name,
  date,
  weight,
  CASE 
    WHEN weight <= prev_weight AND prev_weight <= prev_weight_2 AND prev_weight_2 <= prev_weight_3
    THEN 'Potential Plateau'
    ELSE 'Progressing'
  END as progression_status
FROM exercise_progression
WHERE prev_weight_3 IS NOT NULL;
```

## API Endpoints to Implement

### 1. Strength Analytics
- `GET /api/analytics/strength-progression/{exercise_name}` - Exercise strength progression over time
- `GET /api/analytics/personal-records` - All personal records
- `GET /api/analytics/estimated-orm/{exercise_name}` - Estimated 1RM progression

### 2. Volume Analytics
- `GET /api/analytics/volume-trends` - Weekly/monthly volume trends
- `GET /api/analytics/workout-volume/{workout_id}` - Individual workout volume analysis

### 3. Consistency Analytics
- `GET /api/analytics/workout-frequency` - Workout frequency over time
- `GET /api/analytics/consistency-streaks` - Current and historical workout streaks

### 4. Exercise Analytics
- `GET /api/analytics/exercise-frequency` - Most/least performed exercises
- `GET /api/analytics/exercise-progression/{exercise_name}` - Detailed exercise progression
- `GET /api/analytics/exercise-difficulty/{exercise_name}` - ORM percentage changes

### 5. Program Analytics
- `GET /api/analytics/program-adherence` - Program completion rates
- `GET /api/analytics/superset-analysis` - Superset performance analysis

### 6. Cardio Analytics
- `GET /api/analytics/cardio-progression` - Cardio endurance improvements
- `GET /api/analytics/cardio-sessions` - Cardio session analysis

### 7. Advanced Analytics
- `GET /api/analytics/plateau-detection` - Identify potential strength plateaus
- `GET /api/analytics/strength-to-weight-ratio` - Relative strength metrics

## Frontend Implementation Suggestions

### 1. Dashboard Overview
- Weekly volume chart
- Workout frequency calendar
- Personal records highlights
- Current streak display

### 2. Exercise-Specific Analytics
- Weight progression charts
- Volume progression charts
- Estimated 1RM progression
- Plateau detection alerts

### 3. Program Analytics
- Program adherence metrics
- Workout completion rates
- Superset performance analysis

### 4. Comparative Analytics
- Month-over-month comparisons
- Year-over-year progress
- Strength-to-weight ratio trends

## Database Indexes for Performance

```sql
-- Indexes for analytics queries
CREATE INDEX idx_exercises_performed_name_date ON exercises_performed(name, date);
CREATE INDEX idx_exercises_performed_type ON exercises_performed(_type);
CREATE INDEX idx_exercises_performed_workout_id ON exercises_performed(workout_id);
CREATE INDEX idx_workouts_performed_date ON workouts_performed(date);
CREATE INDEX idx_workouts_performed_user_id ON workouts_performed(user_id);
CREATE INDEX idx_exercises_performed_superset ON exercises_performed(is_superset, superset_group);
```

## Implementation Priority

### Phase 1 (High Priority)
1. Strength progression analytics
2. Volume tracking
3. Workout frequency analysis
4. Personal records tracking

### Phase 2 (Medium Priority)
1. Consistency metrics
2. Exercise-specific analytics
3. Program adherence tracking

### Phase 3 (Advanced Features)
1. Plateau detection
2. Strength-to-weight ratios
3. Superset analysis
4. Cardio progression tracking

## Data Privacy Considerations

- All analytics should be user-specific (filtered by user_id)
- Consider data retention policies for long-term analytics
- Ensure GDPR compliance for data export/deletion
- Anonymize data for aggregate analytics if sharing insights

## Performance Considerations

- Use materialized views for complex analytics queries
- Implement caching for frequently accessed analytics
- Consider data aggregation tables for real-time dashboards
- Use proper indexing for query optimization
- Implement pagination for large result sets

This plan provides a comprehensive foundation for implementing powerful analytics features that will give users valuable insights into their fitness progress and help them optimize their training.
