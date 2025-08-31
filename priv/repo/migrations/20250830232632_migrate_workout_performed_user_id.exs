defmodule LiftskitBackend.Repo.Migrations.MigrateWorkoutPerformedUserId do
  use Ecto.Migration

  def change do
    rename table(:workouts_performed), :user_id, to: :userId
  end
end
