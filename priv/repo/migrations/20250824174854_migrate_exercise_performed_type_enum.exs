defmodule LiftskitBackend.Repo.Migrations.MigrateExercisePerformedTypeEnum do
  use Ecto.Migration

  def change do
    alter table(:exercise_performed) do
      modify :_type, :string, from: :enum, to: :enum, values: [:Strength, :Bodyweight, :Cardio]
    end
  end
end
