defmodule LiftskitBackend.Repo.Migrations.RemoveDescriptionFromProgram do
  use Ecto.Migration

  def change do
    alter table(:programs) do
      remove :description
    end
  end

  def down do
    alter table(:programs) do
      add :description, :string
    end
  end
end
