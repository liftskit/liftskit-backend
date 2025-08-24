defmodule LiftskitBackend.OfficialExercisesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.OfficialExercises` context.
  """

  @doc """
  Generate a unique official_exercise name.
  """
  def unique_official_exercise_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a official_exercise.
  """
  def official_exercise_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: unique_official_exercise_name()
      })

    {:ok, official_exercise} = LiftskitBackend.OfficialExercises.create_official_exercise(scope, attrs)
    official_exercise
  end
end
