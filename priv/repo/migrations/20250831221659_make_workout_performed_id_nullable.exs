defmodule LiftskitBackend.Repo.Migrations.MakeWorkoutPerformedIdNullable do
  use Ecto.Migration

  def change do
    # Drop the existing foreign key constraint first
    drop constraint(:exercise_performed, "exercise_performed_workout_performed_id_fkey")

    # Then modify the column to allow null values
    alter table(:exercise_performed) do
      modify :workout_performed_id, references(:workouts_performed, on_delete: :delete_all), null: true
    end
  end
end
