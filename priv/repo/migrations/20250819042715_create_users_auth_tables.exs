defmodule LiftskitBackend.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    # Add missing fields to existing users table
    alter table(:users) do
      add :hashed_password, :string
      add :confirmed_at, :utc_datetime
    end

    # Update email field to be citext and not null
    execute "ALTER TABLE users ALTER COLUMN email TYPE citext"
    execute "ALTER TABLE users ALTER COLUMN email SET NOT NULL"

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :authenticated_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
