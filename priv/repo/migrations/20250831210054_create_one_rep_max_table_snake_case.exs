defmodule LiftskitBackend.Repo.Migrations.CreateOneRepMaxTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:one_rep_max) do
      add :exercise_name, :string
      add :one_rep_max, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:one_rep_max, [:user_id])
    create unique_index(:one_rep_max, [:exercise_name, :user_id])
  end
end
