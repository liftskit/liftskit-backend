defmodule LiftskitBackend.Repo.Migrations.CreateExercises do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :ormPercent, :decimal
      add :reps, :integer
      add :sets, :integer
      add :time, :string, default: nil
      add :weight, :integer
      add :isSuperset, :boolean, default: false, null: false
      add :exerciseRoot, references(:exercise_roots, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:exercises, [:user_id])

    create index(:exercises, [:exerciseRoot])
  end
end
