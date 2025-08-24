defmodule LiftskitBackend.Repo.Migrations.RenameColumnsToCamelCase do
  use Ecto.Migration

  def change do
    # Rename program_id to programId in workouts table
    rename table(:workouts), :program_id, to: :programId

    # Rename user_id to userId in programs table
    rename table(:programs), :user_id, to: :userId
  end
end
