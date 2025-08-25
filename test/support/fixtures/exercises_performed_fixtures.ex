defmodule LiftskitBackend.ExercisesPerformedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.ExercisesPerformed` context.
  """

  @doc """
  Generate a exercise_performed.
  """
  def exercise_performed_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        _type: :strength,
        name: "some name",
        reps: 42,
        sets: 42,
        time: "some time",
        weight: 42
      })

    {:ok, exercise_performed} = LiftskitBackend.ExercisesPerformed.create_exercise_performed(scope, attrs)
    exercise_performed
  end
end
