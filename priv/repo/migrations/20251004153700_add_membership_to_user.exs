defmodule LiftskitBackend.Repo.Migrations.AddMembershipToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :membership_status, :string
      add :membership_expires_at, :utc_datetime
    end
  end
end
