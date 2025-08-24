defmodule LiftskitBackend.WorkoutsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Workouts` context.
  """

  @doc """
  Generate a workout.
  """
  def workout_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        bestWorkoutTime: "some bestWorkoutTime",
        name: "some name"
      })

    {:ok, workout} = LiftskitBackend.Workouts.create_workout(scope, attrs)
    workout
  end
end
