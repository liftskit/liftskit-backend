defmodule LiftskitBackend.Repo.Migrations.CreateWorkoutsPerformedTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:workouts_performed) do
      add :program_name, :string
      add :workout_date, :utc_datetime
      add :workout_time, :integer
      add :workout_name, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:workouts_performed, [:user_id])
  end
end
