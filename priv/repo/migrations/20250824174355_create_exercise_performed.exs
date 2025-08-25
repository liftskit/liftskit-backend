defmodule LiftskitBackend.Repo.Migrations.CreateExercisePerformed do
  use Ecto.Migration

  def change do
    create table(:exercise_performed) do
      add :_type, :string
      add :name, :string
      add :reps, :integer
      add :sets, :integer
      add :time, :string
      add :weight, :integer
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:exercise_performed, [:user_id])
  end
end
