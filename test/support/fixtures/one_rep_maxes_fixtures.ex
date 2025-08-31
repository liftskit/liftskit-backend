defmodule LiftskitBackend.OneRepMaxesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.OneRepMaxes` context.
  """

  @doc """
  Generate a unique one_rep_max exercise_name.
  """
  def unique_one_rep_max_exercise_name, do: "some exercise_name#{System.unique_integer([:positive])}"

  @doc """
  Generate a one_rep_max.
  """
  def one_rep_max_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        exercise_name: unique_one_rep_max_exercise_name(),
        one_rep_max: 42
      })

    {:ok, one_rep_max} = LiftskitBackend.OneRepMaxes.create_one_rep_max(scope, attrs)
    one_rep_max
  end
end
