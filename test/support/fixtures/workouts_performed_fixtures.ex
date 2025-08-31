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
        program_name: "some program_name",
        workout_date: ~U[2025-08-23 18:56:00Z],
        workout_name: "some workout_name",
        workout_time: 42
      })

    {:ok, workout_performed} = LiftskitBackend.WorkoutsPerformed.create_workout_performed(scope, attrs)
    workout_performed
  end
end
