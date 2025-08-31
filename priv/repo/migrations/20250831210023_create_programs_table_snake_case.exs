defmodule LiftskitBackend.Repo.Migrations.CreateProgramsTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:programs) do
      add :name, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:programs, [:user_id])
    create unique_index(:programs, [:name, :user_id])
  end
end
