defmodule LiftskitBackend.Repo.Migrations.RemoveUserIdFromTag do
  use Ecto.Migration

  def change do
    # The user_id column was never created, so we don't need to remove it
    # This migration is a no-op
  end
end
