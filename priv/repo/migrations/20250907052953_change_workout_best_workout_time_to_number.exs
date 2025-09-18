defmodule LiftskitBackend.Repo.Migrations.ChangeWorkoutBestWorkoutTimeToNumber do
  use Ecto.Migration

  def up do
    # First, update any non-numeric values to a default large number
    execute "UPDATE workouts SET best_workout_time = '999999999' WHERE best_workout_time !~ '^[0-9]+$'"

    # Then convert the column to integer using explicit casting
    execute "ALTER TABLE workouts ALTER COLUMN best_workout_time TYPE integer USING best_workout_time::integer"
  end

  def down do
    alter table(:workouts) do
      modify :best_workout_time, :string
    end
  end
end
