defmodule LiftskitBackend.OneRepMaxesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.OneRepMaxes` context.
  """

  @doc """
  Generate a unique one_rep_max exerciseName.
  """
  def unique_one_rep_max_exerciseName, do: "some exerciseName#{System.unique_integer([:positive])}"

  @doc """
  Generate a one_rep_max.
  """
  def one_rep_max_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        exerciseName: unique_one_rep_max_exerciseName(),
        oneRepMax: 42
      })

    {:ok, one_rep_max} = LiftskitBackend.OneRepMaxes.create_one_rep_max(scope, attrs)
    one_rep_max
  end
end
