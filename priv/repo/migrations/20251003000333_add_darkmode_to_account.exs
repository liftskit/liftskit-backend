defmodule LiftskitBackend.Repo.Migrations.AddDarkmodeToAccount do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :dark_mode, :boolean, default: false
    end
  end
end
