defmodule LiftskitBackend.Repo.Migrations.DropExerciseSupersets do
  use Ecto.Migration

  def change do
    drop table(:exercise_supersets)
  end
end
