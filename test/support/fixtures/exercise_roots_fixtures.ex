defmodule LiftskitBackend.ExerciseRootsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.ExerciseRoots` context.
  """

  @doc """
  Generate a unique exercise_root name.
  """
  def unique_exercise_root_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a exercise_root.
  """
  def exercise_root_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        _type: :required,
        name: unique_exercise_root_name()
      })

    {:ok, exercise_root} = LiftskitBackend.ExerciseRoots.create_exercise_root(scope, attrs)
    exercise_root
  end
end
