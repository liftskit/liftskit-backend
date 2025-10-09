defmodule LiftskitBackend.Repo.Migrations.AddWeightliftingToExerciseType do
  use Ecto.Migration

  def change do
    # Just update existing records to have Weightlifting as default
    # The _type column already exists, we just need to set default values
    execute "UPDATE exercises SET _type = 'Weightlifting' WHERE _type IS NULL OR _type = ''"
    execute "UPDATE exercise_performed SET _type = 'Weightlifting' WHERE _type IS NULL OR _type = ''"
  end
end
