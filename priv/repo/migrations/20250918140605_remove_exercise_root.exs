defmodule LiftskitBackend.Repo.Migrations.RemoveExerciseRoot do
  use Ecto.Migration

  def change do
    alter table(:exercises) do
      remove :exercise_root_id
      add :name, :string
      add :_type, :string
    end

    drop_if_exists table(:exercise_roots)
  end
end
