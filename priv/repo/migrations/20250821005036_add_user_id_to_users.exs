defmodule LiftskitBackend.Repo.Migrations.AddUserIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_id, references(:users, type: :id, on_delete: :delete_all)
    end

    create index(:users, [:user_id])
  end
end
