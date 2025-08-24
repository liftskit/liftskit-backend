# MongoDB to PostgreSQL Migration Plan
## Elixir/Phoenix with Ecto

### Overview
This document outlines the migration strategy for converting MongoDB schemas to PostgreSQL tables using Elixir/Phoenix and Ecto.

### Current MongoDB Schema Analysis
- **Users**: Central entity with authentication and profile data
- **ExerciseRoot**: User-defined exercise names (reduces workout data redundancy)
- **ExerciseRootOfficial**: Platform-curated, supported exercises (for recommendations, 1RM tracking)
- **Exercises**: Workout-specific exercise instances
- **Workouts**: Collections of exercises
- **WorkoutPerformed**: Completed workout records
- **ExercisePerformed**: Completed exercise records
- **ProgramBlock**: Workout programs and scheduling
- **OneRepMax**: User performance metrics
- **Comments**: User feedback and discussion system
- **Tags**: Categorization system for workouts
- **WorkoutShared**: Public workout sharing with social features
- **Membership**: User subscription management

### Migration Order (Dependencies First)

#### Phase 1: Independent Tables (No Foreign Keys)
Start with tables that have no dependencies:

1. **`users`** - No foreign keys, referenced by many others
2. **`exercise_root_officials`** - No foreign keys, platform-curated exercises
3. **`tags`** - No foreign keys, workout categorization

#### Phase 2: First-Level Dependencies
Tables that only reference the independent tables:

4. **`exercise_roots`** - References `users.id` (user-defined exercises)
5. **`workouts`** - References `users.id`
6. **`one_rep_maxes`** - References `users.id` and `exercise_root_officials.id`
7. **`memberships`** - References `users.id`

#### Phase 3: Second-Level Dependencies
Tables that reference the first-level tables:

8. **`exercises`** - References `workouts.id` and `exercise_roots.id`
9. **`workouts_performed`** - References `users.id` (via username)
10. **`workouts_shared`** - References `users.id` and `tags.id`

#### Phase 4: Third-Level Dependencies
Tables that reference second-level tables:

11. **`exercises_performed`** - References `workouts_performed.id`
12. **`program_blocks`** - References `users.id` and `workouts.id`
13. **`comments`** - References `users.id`, `workouts.id`, and `comments.id` (replies)

#### Phase 5: Junction Tables
Many-to-many relationship tables:

14. **`exercise_superset_relationships`** - References `exercises.id` (self-referencing)
15. **`program_workouts`** - References `program_blocks.id` and `workouts.id`
16. **`workout_shared_exercises`** - References `workouts_shared.id` and `exercises.id`
17. **`workout_shared_tags`** - References `workouts_shared.id` and `tags.id`
18. **`exercise_root_mappings`** - Links user exercises to official exercises

### CLI Commands in Order

```bash
# Phase 1: Independent tables
mix ecto.gen.migration create_users
mix ecto.gen.migration create_exercise_root_officials
mix ecto.gen.migration create_tags

# Phase 2: First-level dependencies
mix ecto.gen.migration create_exercise_roots
mix ecto.gen.migration create_workouts
mix ecto.gen.migration create_one_rep_maxes
mix ecto.gen.migration create_memberships

# Phase 3: Second-level dependencies
mix ecto.gen.migration create_exercises
mix ecto.gen.migration create_workouts_performed
mix ecto.gen.migration create_workouts_shared

# Phase 4: Third-level dependencies
mix ecto.gen.migration create_exercises_performed
mix ecto.gen.migration create_program_blocks
mix ecto.gen.migration create_comments

# Phase 5: Junction tables
mix ecto.gen.migration create_exercise_superset_relationships
mix ecto.gen.migration create_program_workouts
mix ecto.gen.migration create_workout_shared_exercises
mix ecto.gen.migration create_workout_shared_tags
mix ecto.gen.migration create_exercise_root_mappings
```

### Table Structure Reference

#### Core Tables (Strong entities)

**users**
```sql
users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  is_premium BOOLEAN DEFAULT false,
  is_blacklisted BOOLEAN DEFAULT false,
  is_banned BOOLEAN DEFAULT false,
  last_paid DATE,
  total_paid DECIMAL(10,2),
  public_key TEXT,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**exercise_root_officials**
```sql
exercise_root_officials (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL, -- Global uniqueness for platform
  type VARCHAR(50) NOT NULL, -- bodyweight, weights%, weights, cardio, other
  video_uri TEXT,
  is_active BOOLEAN DEFAULT true,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**exercise_roots**
```sql
exercise_roots (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(creator_id, name) -- Users can have same exercise names
)
```

#### Relationship Tables (Weak entities)

**workouts**
```sql
workouts (
  id SERIAL PRIMARY KEY,
  creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  workout_name VARCHAR(255) NOT NULL,
  program_name VARCHAR(255) NOT NULL,
  best_workout_time VARCHAR(50) DEFAULT '0',
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  UNIQUE(creator_id, workout_name, program_name)
)
```

**exercises**
```sql
exercises (
  id SERIAL PRIMARY KEY,
  workout_id INTEGER REFERENCES workouts(id) ON DELETE CASCADE,
  exercise_root_id INTEGER REFERENCES exercise_roots(id),
  orm_percent DECIMAL(5,2),
  reps INTEGER NOT NULL,
  sets INTEGER NOT NULL,
  time VARCHAR(50) DEFAULT '',
  weight DECIMAL(8,2),
  is_superset BOOLEAN DEFAULT false,
  order_index INTEGER NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**workouts_performed**
```sql
workouts_performed (
  id SERIAL PRIMARY KEY,
  creator_username VARCHAR(255) NOT NULL,
  workout_name VARCHAR(255) NOT NULL,
  program_name VARCHAR(255) NOT NULL,
  workout_date DATE NOT NULL,
  workout_time VARCHAR(50) NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**exercises_performed**
```sql
exercises_performed (
  id SERIAL PRIMARY KEY,
  workout_performed_id INTEGER REFERENCES workouts_performed(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  reps INTEGER NOT NULL,
  sets INTEGER NOT NULL,
  time VARCHAR(50) DEFAULT '',
  weight DECIMAL(8,2),
  is_superset BOOLEAN DEFAULT false,
  order_index INTEGER NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**one_rep_maxes**
```sql
one_rep_maxes (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  exercise_name VARCHAR(255) NOT NULL,
  one_rep_max DECIMAL(8,2) NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**program_blocks**
```sql
program_blocks (
  id SERIAL PRIMARY KEY,
  username_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  program_block_name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  next_workout_id INTEGER REFERENCES workouts(id),
  next_workout_date DATE,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

#### Junction Tables (Many-to-many relationships)

**exercise_superset_relationships**
```sql
exercise_superset_relationships (
  id SERIAL PRIMARY KEY,
  primary_exercise_id INTEGER REFERENCES exercises(id) ON DELETE CASCADE,
  superset_exercise_id INTEGER REFERENCES exercises(id) ON DELETE CASCADE,
  inserted_at TIMESTAMP NOT NULL
)
```

**workout_shared_exercises**
```sql
workout_shared_exercises (
  id SERIAL PRIMARY KEY,
  workout_shared_id INTEGER REFERENCES workouts_shared(id) ON DELETE CASCADE,
  exercise_id INTEGER REFERENCES exercises(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**workout_shared_tags**
```sql
workout_shared_tags (
  id SERIAL PRIMARY KEY,
  workout_shared_id INTEGER REFERENCES workouts_shared(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
  inserted_at TIMESTAMP NOT NULL
)
```

**exercise_root_mappings**
```sql
exercise_root_mappings (
  id SERIAL PRIMARY KEY,
  exercise_root_id INTEGER REFERENCES exercise_roots(id) ON DELETE CASCADE,
  official_exercise_id INTEGER REFERENCES exercise_root_officials(id),
  confidence_score DECIMAL(3,2), -- How confident we are in the mapping
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**program_workouts**
```sql
program_workouts (
  id SERIAL PRIMARY KEY,
  program_block_id INTEGER REFERENCES program_blocks(id) ON DELETE CASCADE,
  workout_id INTEGER REFERENCES workouts(id) ON DELETE CASCADE,
  vanity_name VARCHAR(255) NOT NULL,
  order_index INTEGER NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**tags**
```sql
tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**workouts_shared**
```sql
workouts_shared (
  id SERIAL PRIMARY KEY,
  creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  workout_name VARCHAR(255) NOT NULL,
  program_name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(100) NOT NULL,
  difficulty VARCHAR(50) NOT NULL,
  thumbnail_url TEXT NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**comments**
```sql
comments (
  id SERIAL PRIMARY KEY,
  creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  workout_id INTEGER REFERENCES workouts(id) ON DELETE CASCADE,
  parent_comment_id INTEGER REFERENCES comments(id), -- For replies
  text TEXT NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

**memberships**
```sql
memberships (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  last_paid DATE NOT NULL,
  inserted_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
)
```

### Key Migration Considerations

#### Data Type Conversions
- **ObjectId → SERIAL/BIGSERIAL**: Replace MongoDB ObjectIds with auto-incrementing integers
- **String dates → DATE/TIMESTAMP**: Convert string date representations to proper date types
- **Embedded arrays → Junction tables**: Use many-to-many relationship tables for arrays
- **Decimal precision**: Use appropriate DECIMAL types for weights and percentages

#### Indexing Strategy
- **Primary keys**: All tables get auto-indexed primary keys
- **Foreign keys**: Index all foreign key columns for join performance
- **Unique constraints**: Maintain business logic uniqueness (e.g., user + workout + program)
- **Composite indexes**: For frequently queried combinations

#### Phoenix/Ecto Implementation
- **Schemas**: Create Ecto schemas with proper associations
- **Migrations**: Use `mix ecto.gen.migration` for each table
- **Associations**: Define `has_many`, `belongs_to`, and `many_to_many` relationships
- **Validations**: Move business logic from Mongoose to Ecto changesets

### Migration Phases Summary

1. **Phase 1**: Create independent tables (users, exercise_root_officials, tags)
2. **Phase 2**: Create first-level dependencies (exercise_roots, workouts, one_rep_maxes, memberships)
3. **Phase 3**: Create second-level dependencies (exercises, workouts_performed, workouts_shared)
4. **Phase 4**: Create third-level dependencies (exercises_performed, program_blocks, comments)
5. **Phase 5**: Create junction tables (exercise_superset_relationships, program_workouts, workout_shared_exercises, workout_shared_tags, exercise_root_mappings)
6. **Phase 6**: Data migration and validation
7. **Phase 7**: Update application code and testing

### Smart Exercise Taxonomy Design

This migration preserves your sophisticated exercise management system:

- **`exercise_root_officials`**: Platform-curated exercises for recommendations, 1RM tracking, and standardization
- **`exercise_roots`**: User-defined exercise names that reduce workout data redundancy
- **`exercise_root_mappings`**: Optional linking between user exercises and official exercises for enhanced features
- **Benefits**: Maintains user flexibility while enabling platform standardization and recommendation systems

### Benefits of This Approach

- **Data integrity**: Foreign key constraints prevent orphaned records
- **Query performance**: Optimized joins and indexing
- **Scalability**: Better performance for complex queries and large datasets
- **Maintainability**: Clear relationships and easier debugging
- **ACID compliance**: Full transactional support
- **Business logic preservation**: Maintains your smart exercise taxonomy design

### Next Steps

1. Set up your Phoenix project with Ecto
2. Configure your database connection
3. Follow the migration order above
4. Create Ecto schemas for each table
5. Test each migration step by step
6. Migrate your data from MongoDB
7. Update your application code to use Ecto instead of Mongoose

### Troubleshooting

- **Foreign key errors**: Ensure referenced tables exist before creating dependent tables
- **Migration rollbacks**: Use `mix ecto.rollback` to undo migrations in reverse order
- **Data validation**: Test each migration with sample data before proceeding
- **Performance**: Monitor query performance and add indexes as needed
