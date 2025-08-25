defmodule LiftskitBackend.Repo.Migrations.MigrateWorkoutPerformedExercisePerformed do
  use Ecto.Migration

  def change do
    alter table(:workouts_performed) do
      add :exercisesPerformed, {:array, :bigint}
    end
  end
end
