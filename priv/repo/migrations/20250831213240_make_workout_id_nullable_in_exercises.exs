defmodule LiftskitBackend.Repo.Migrations.MakeWorkoutIdNullableInExercises do
  use Ecto.Migration

  def change do
    # Drop the existing foreign key constraint
    drop constraint(:exercises, "exercises_workout_id_fkey")

    # Modify the column to be nullable
    alter table(:exercises) do
      modify :workout_id, references(:workouts, on_delete: :delete_all), null: true
    end
  end
end
