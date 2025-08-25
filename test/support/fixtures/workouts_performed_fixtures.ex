defmodule LiftskitBackend.WorkoutsPerformedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.WorkoutsPerformed` context.
  """

  @doc """
  Generate a workout_performed.
  """
  def workout_performed_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        programName: "some programName",
        workoutDate: ~U[2025-08-23 18:56:00Z],
        workoutName: "some workoutName",
        workoutTime: 42
      })

    {:ok, workout_performed} = LiftskitBackend.WorkoutsPerformed.create_workout_performed(scope, attrs)
    workout_performed
  end
end
