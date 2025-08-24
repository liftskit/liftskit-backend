defmodule LiftskitBackend.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Tags` context.
  """

  @doc """
  Generate a unique tag name.
  """
  def unique_tag_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a tag.
  """
  def tag_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: unique_tag_name()
      })

    {:ok, tag} = LiftskitBackend.Tags.create_tag(scope, attrs)
    tag
  end
end
