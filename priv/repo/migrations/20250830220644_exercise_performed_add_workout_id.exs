defmodule LiftskitBackend.Repo.Migrations.ExercisePerformedAddWorkoutId do
  use Ecto.Migration

  def change do
    alter table(:exercise_performed) do
      add :workoutPerformedId, references(:workouts_performed, on_delete: :delete_all)
    end

    create index(:exercise_performed, [:workoutPerformedId])
  end
end
