defmodule LiftskitBackend.Repo.Migrations.CreateExerciseSupersetsTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:exercise_supersets) do
      add :exercise_id, references(:exercises, on_delete: :delete_all), null: false
      add :superset_exercise_id, references(:exercises, on_delete: :delete_all), null: false
      add :order, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:exercise_supersets, [:exercise_id])
    create index(:exercise_supersets, [:superset_exercise_id])
    create unique_index(:exercise_supersets, [:exercise_id, :superset_exercise_id])
  end
end
