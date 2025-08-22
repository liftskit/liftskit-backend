defmodule LiftskitBackend.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :created, :utc_datetime
      add :from_user_id, references(:users, on_delete: :nothing)
      add :to_user_id, references(:users, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:user_id])

    create index(:messages, [:from_user_id])
    create index(:messages, [:to_user_id])
  end
end
