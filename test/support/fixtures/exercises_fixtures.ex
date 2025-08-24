defmodule LiftskitBackend.ExercisesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Exercises` context.
  """

  @doc """
  Generate a exercise.
  """
  def exercise_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        isSuperset: true,
        ormPercent: "120.5",
        reps: 42,
        sets: 42,
        time: "some time",
        weight: 42
      })

    {:ok, exercise} = LiftskitBackend.Exercises.create_exercise(scope, attrs)
    exercise
  end
end
