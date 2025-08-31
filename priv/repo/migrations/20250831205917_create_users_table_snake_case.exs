defmodule LiftskitBackend.Repo.Migrations.CreateUsersTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :citext, null: false
      add :hashed_password, :string
      add :confirmed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
