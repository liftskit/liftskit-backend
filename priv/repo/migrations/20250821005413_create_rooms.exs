defmodule LiftskitBackend.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:rooms, [:user_id])

    create unique_index(:rooms, [:name])
  end
end
