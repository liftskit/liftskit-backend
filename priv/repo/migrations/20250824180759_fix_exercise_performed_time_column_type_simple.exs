defmodule LiftskitBackend.Repo.Migrations.FixExercisePerformedTimeColumnTypeSimple do
  use Ecto.Migration

  def change do
    # Drop the old string column
    alter table(:exercise_performed) do
      remove :time
    end

    # Add the new integer column
    alter table(:exercise_performed) do
      add :time, :integer
    end
  end
end
