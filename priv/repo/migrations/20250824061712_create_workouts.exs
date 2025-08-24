defmodule LiftskitBackend.Repo.Migrations.CreateWorkouts do
  use Ecto.Migration

  def change do
    create table(:workouts) do
      add :name, :string
      add :bestWorkoutTime, :string
      add :program_id, references(:programs, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:workouts, [:user_id])

    create index(:workouts, [:program_id])
  end
end
