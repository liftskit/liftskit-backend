defmodule LiftskitBackend.Repo.Migrations.CreateExerciseRootsTableSnakeCase do
  use Ecto.Migration

  def change do
    create table(:exercise_roots) do
      add :name, :string
      add :_type, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:exercise_roots, [:user_id])
    create unique_index(:exercise_roots, [:name, :user_id])
  end
end
