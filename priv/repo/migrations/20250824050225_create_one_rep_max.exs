defmodule LiftskitBackend.Repo.Migrations.CreateOneRepMax do
  use Ecto.Migration

  def change do
    create table(:one_rep_max) do
      add :exerciseName, :string
      add :oneRepMax, :integer
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:one_rep_max, [:user_id])
    create unique_index(:one_rep_max, [:exerciseName])
  end
end
