defmodule LiftskitBackend.Repo.Migrations.RemoveUserIdFromExerciseRoots do
  use Ecto.Migration

  def change do
    # Drop the unique index that includes user_id
    drop_if_exists index(:exercise_roots, [:name, :user_id])

    # Drop the user_id index
    drop_if_exists index(:exercise_roots, [:user_id])

    # Remove the user_id column
    alter table(:exercise_roots) do
      remove :user_id
    end

    # Create a new unique index on just the name
    create unique_index(:exercise_roots, [:name])
  end
end
