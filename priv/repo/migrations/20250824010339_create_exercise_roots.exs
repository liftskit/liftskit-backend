defmodule LiftskitBackend.Repo.Migrations.CreateExerciseRoots do
  use Ecto.Migration

  def change do
    create table(:exercise_roots) do
      add :name, :string
      add :_type, :string
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:exercise_roots, [:user_id])

    create unique_index(:exercise_roots, [:name])
  end
end
