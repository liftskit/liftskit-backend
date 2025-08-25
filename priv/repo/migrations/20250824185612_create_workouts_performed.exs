defmodule LiftskitBackend.Repo.Migrations.CreateWorkoutsPerformed do
  use Ecto.Migration

  def change do
    create table(:workouts_performed) do
      add :programName, :string
      add :workoutDate, :utc_datetime
      add :workoutTime, :integer
      add :workoutName, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:workouts_performed, [:user_id])
  end
end
