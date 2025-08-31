defmodule LiftskitBackend.Repo.Migrations.CreateWorkoutsTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:workouts) do
      add :name, :string
      add :best_workout_time, :string
      add :program_id, references(:programs, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:workouts, [:program_id])
  end
end
