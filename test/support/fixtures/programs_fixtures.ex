defmodule LiftskitBackend.ProgramsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Programs` context.
  """

  @doc """
  Generate a unique program name.
  """
  def unique_program_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a program.
  """
  def program_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: unique_program_name()
      })

    {:ok, program} = LiftskitBackend.Programs.create_program(scope, attrs)
    program
  end
end
