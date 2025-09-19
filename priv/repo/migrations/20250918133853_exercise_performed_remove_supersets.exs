defmodule LiftskitBackend.Repo.Migrations.ExercisePerformedRemoveSupersets do
  use Ecto.Migration

  def change do
    drop table(:exercise_performed_supersets)
    drop table(:exercise_supersets)

    alter table(:exercise_performed) do
      add :parent_id, references(:exercise_performed, on_delete: :delete_all)
      add :child_id, references(:exercise_performed, on_delete: :delete_all)
    end

    alter table(:exercises) do
      add :parent_id, references(:exercises, on_delete: :delete_all)
      add :child_id, references(:exercises, on_delete: :delete_all)
    end

    create index(:exercise_performed, [:parent_id])
    create index(:exercise_performed, [:child_id])
    create index(:exercises, [:parent_id])
    create index(:exercises, [:child_id])
  end
end
