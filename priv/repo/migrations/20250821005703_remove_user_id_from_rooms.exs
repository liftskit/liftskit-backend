defmodule LiftskitBackend.Repo.Migrations.RemoveUserIdFromRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      remove :user_id
    end

    execute "DROP INDEX IF EXISTS rooms_user_id_index"
  end
end
