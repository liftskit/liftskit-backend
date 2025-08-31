defmodule LiftskitBackend.Repo.Migrations.ExercisePerformedRemoveUserId do
  use Ecto.Migration

  def change do
    alter table(:exercise_performed) do
      remove :user_id
    end
  end
end
