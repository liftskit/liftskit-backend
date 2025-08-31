defmodule LiftskitBackend.Repo.Migrations.CreateExercisePerformedTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:exercise_performed) do
      add :_type, :string
      add :name, :string
      add :reps, :integer
      add :sets, :integer
      add :time, :integer
      add :weight, :integer
      add :workout_performed_id, references(:workouts_performed, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:exercise_performed, [:workout_performed_id])
  end
end
