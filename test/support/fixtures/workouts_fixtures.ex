defmodule LiftskitBackend.WorkoutsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Workouts` context.
  """

  @doc """
  Generate a workout.
  """
  def workout_fixture(scope, attrs \\ %{}) do
    # Create a program first since workouts require a program
    program = LiftskitBackend.ProgramsFixtures.program_fixture(scope)

    attrs =
      Enum.into(attrs, %{
        best_workout_time: "some best_workout_time",
        name: "some name",
        program_id: program.id
      })

    {:ok, workout} = LiftskitBackend.Workouts.create_workout(scope, attrs)
    workout
  end
end
