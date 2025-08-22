defmodule LiftskitBackend.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Rooms` context.
  """

  @doc """
  Generate a unique room name.
  """
  def unique_room_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: unique_room_name()
      })

    {:ok, room} = LiftskitBackend.Rooms.create_room(attrs)
    room
  end
end
