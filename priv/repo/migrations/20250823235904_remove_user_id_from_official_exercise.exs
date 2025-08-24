defmodule LiftskitBackend.Repo.Migrations.RemoveUserIdFromOfficialExercise do
  use Ecto.Migration

  def change do
    alter table(:official_exercises) do
      remove :user_id
    end
  end
end
