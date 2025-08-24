defmodule LiftskitBackend.Repo.Migrations.CreateOne-rep-max do
  use Ecto.Migration

  def change do
    create table(:one-rep-max) do
      add :exerciseName, :string
      add :oneRepMax, :integer
      add :username, references(:users, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:one-rep-max, [:user_id])

    create unique_index(:one-rep-max, [:exerciseName])
    create index(:one-rep-max, [:username])
  end
end
