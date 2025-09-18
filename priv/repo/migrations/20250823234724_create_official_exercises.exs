defmodule LiftskitBackend.Repo.Migrations.CreateOfficialExercises do
  use Ecto.Migration

  def change do
    create table(:official_exercises) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:official_exercises, [:name])
  end
end
