defmodule LiftskitBackend.Repo.Migrations.RemoveUserIdFromWorkouts do
  use Ecto.Migration

  def change do
    alter table(:workouts) do
      remove :user_id
    end
  end
end
