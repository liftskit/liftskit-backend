defmodule LiftskitBackend.Repo.Migrations.MigrateExercisePerformedTime do
  use Ecto.Migration

  def change do
    alter table(:exercise_performed) do
      modify :time, :integer
    end
  end
end
