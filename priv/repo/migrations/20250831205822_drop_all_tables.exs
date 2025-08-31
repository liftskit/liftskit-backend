defmodule LiftskitBackend.Repo.Migrations.DropAllTables do
  use Ecto.Migration

  def up do
    # Drop all tables in dependency order (children first, then parents)

    # Drop junction tables and dependent tables first
    drop_if_exists table(:exercise_supersets)
    drop_if_exists table(:exercise_performed)
    drop_if_exists table(:exercises)
    drop_if_exists table(:workouts_performed)
    drop_if_exists table(:workouts)
    drop_if_exists table(:one_rep_max)
    drop_if_exists table(:programs)
    drop_if_exists table(:exercise_roots)
    drop_if_exists table(:official_exercises)
    drop_if_exists table(:tags)
    drop_if_exists table(:messages)
    drop_if_exists table(:rooms)
    drop_if_exists table(:users_tokens)
    drop_if_exists table(:users)
  end

  def down do
    # This migration is irreversible - we're starting fresh
    # The down function will be implemented by the new table creation migrations
  end
end
