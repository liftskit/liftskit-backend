defmodule LiftskitBackend.Repo.Migrations.RemoveUserIdFromExercises do
  use Ecto.Migration

  def change do
    # Remove the user_id index first
    drop index(:exercises, [:user_id])

    # Remove the user_id column
    alter table(:exercises) do
      remove :user_id
    end
  end
end
