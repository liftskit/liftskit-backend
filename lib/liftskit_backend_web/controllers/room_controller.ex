defmodule LiftskitBackendWeb.RoomController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Rooms

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  def create(conn, params) do
    case Rooms.create_room(params) do
      {:ok, room} ->
        Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "lobby:lobby", {:room_created, %{
          room_name: room.name,
          room_id: room.id
        }})

        conn
        |> put_status(200)
        |> json(%{
          status: "ok",
          name: room.name,
          id: room.id
        })

      {:error, changeset} ->
        # Check if it's a unique constraint error (room already exists)
        if changeset.errors |> Enum.any?(fn {field, _} -> field == :name end) do
          existing_room = Rooms.get_room_by_name(params["name"])
          conn |> put_status(200) |> json(%{
            status: "ok",
            name: existing_room.name,
            id: existing_room.id
          })
        else
          conn |> put_status(422) |> json(%{
            status: "error",
            message: "Room already exists"
          })
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Rooms.delete_room(id) do
      {:ok, _} -> json(conn, %{status: "ok"})
      {:error, :not_found} -> conn |> put_status(404) |> json(%{status: "error", message: "Room not found"})
      {:error, _changeset} -> conn |> put_status(422) |> json(%{status: "error", message: "Room not found"})
    end
  end
end
