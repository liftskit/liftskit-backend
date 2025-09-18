defmodule LiftskitBackend.Repo.Migrations.ChangeExerciseTimeToInteger do
  use Ecto.Migration

  def change do
    # First, update existing string values to integers
    execute "UPDATE exercises SET time = '0' WHERE time IS NULL OR time = ''"
    execute "UPDATE exercises SET time = regexp_replace(time, '[^0-9]', '', 'g') WHERE time ~ '[^0-9]'"

    # Change the column type from string to integer using USING clause
    execute "ALTER TABLE exercises ALTER COLUMN time TYPE integer USING time::integer"
    execute "ALTER TABLE exercises ALTER COLUMN time SET DEFAULT 0"
  end
end
