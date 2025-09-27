defmodule LiftskitBackend.Repo.Migrations.AddLoginCodeExpiresAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :login_code, :string
      add :login_code_expires_at, :utc_datetime
    end
  end
end
