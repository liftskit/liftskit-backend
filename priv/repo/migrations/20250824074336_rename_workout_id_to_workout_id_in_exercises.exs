defmodule LiftskitBackend.Repo.Migrations.RenameWorkoutIdToWorkoutIdInExercises do
  use Ecto.Migration

  def change do
    # Rename workout_id to workoutId in exercises table
    rename table(:exercises), :workout_id, to: :workoutId
  end
end
