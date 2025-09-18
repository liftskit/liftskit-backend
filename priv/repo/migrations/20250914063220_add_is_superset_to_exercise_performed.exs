defmodule LiftskitBackend.Repo.Migrations.AddIsSupersetToExercisePerformed do
  use Ecto.Migration

  def change do
    alter table(:exercise_performed) do
      add :is_superset, :boolean, default: false, null: false
    end
  end
end
