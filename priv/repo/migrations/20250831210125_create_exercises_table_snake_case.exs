defmodule LiftskitBackend.Repo.Migrations.CreateExercisesTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :orm_percent, :decimal
      add :reps, :integer
      add :sets, :integer
      add :time, :string
      add :weight, :integer
      add :is_superset, :boolean, default: false, null: false
      add :workout_id, references(:workouts, on_delete: :delete_all), null: false
      add :exercise_root_id, references(:exercise_roots, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:exercises, [:workout_id])
    create index(:exercises, [:exercise_root_id])
  end
end
