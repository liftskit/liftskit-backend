defmodule LiftskitBackend.Repo.Migrations.CreateExercisePerformedSupersets do
  use Ecto.Migration

  def change do
    create table(:exercise_performed_supersets) do
      add :exercise_performed_id, references(:exercise_performed, on_delete: :delete_all)
      add :superset_exercise_id, references(:exercise_performed, on_delete: :delete_all)
      add :order, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:exercise_performed_supersets, [:exercise_performed_id])
    create index(:exercise_performed_supersets, [:superset_exercise_id])

    create unique_index(:exercise_performed_supersets, [:exercise_performed_id, :superset_exercise_id])
  end
end
