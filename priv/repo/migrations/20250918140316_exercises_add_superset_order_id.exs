defmodule LiftskitBackend.Repo.Migrations.ExercisesAddSupersetOrderId do
  use Ecto.Migration

  def change do
    alter table(:exercises) do
      add :superset_order, :integer
      add :superset_group, :integer
      remove :parent_id
      remove :child_id
    end

    alter table(:exercise_performed) do
      add :superset_order, :integer
      add :superset_group, :integer
      remove :parent_id
      remove :child_id
    end
  end
end
