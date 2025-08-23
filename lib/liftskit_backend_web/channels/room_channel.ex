defmodule LiftskitBackendWeb.RoomChannel do
  use LiftskitBackendWeb, :channel

  alias Phoenix.Presence
  alias LiftskitBackend.Rooms
  alias LiftskitBackendWeb.Presence

  @impl true
  def join("room:" <> room_name, payload, socket) do
    username = Map.get(payload, "username", "Anonymous")
    socket = assign(socket, :username, username)
    socket = assign(socket, :room, room_name)

    # Trigger after_join to handle presence tracking and notification
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_in("new_msg", %{"body" => body, "username" => username}, socket) do
    # Broadcast the message to all users in the room
    broadcast!(socket, "new_msg", %{
      body: body,
      username: username,
      timestamp: DateTime.utc_now()
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in(:after_join, socket) do
    # Step 1: Track the new user's presence in this room
    {:ok, _} =
      Presence.track(socket, socket.assigns.username, %{
        online_at: inspect(System.system_time(:second))
      })

    # Step 2: Get the updated presence state (includes all users)
    presence_state = Presence.list(socket.topic)

    # Step 3: Send the initial state to the joining user
    # broadcast_presence_update(socket, presence_state)

    # Step 4: Broadcast updated count to all existing users in the room
    broadcast_presence_update_to_all(socket, presence_state)
  end

  @impl true
  def handle_in(:after_leave, socket) do
    # Step 1: Remove the user from presence tracking
    Presence.untrack(socket, socket.assigns.username)

    # Step 2: Manually broadcast updated count to all users in the room
    presence_state = Presence.list(socket.topic)
    broadcast_presence_update_to_all(socket, presence_state)

    # Step 3: Check if the room is now empty and clean up if needed
    user_count = map_size(presence_state)
    case user_count do
      0 ->
        delete_empty_room(socket.assigns.room)
        {:noreply, socket}
      _ ->
        {:noreply, socket}
    end
  end

  defp delete_empty_room(room_name) do
    case Rooms.get_room_by_name(room_name) do
      nil ->
        # Room not found, no-op
        :ok
      room ->
        case Rooms.delete_room(room.id) do
          {:ok, _deleted_room} ->
            Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "lobby:lobby", {:room_deleted, %{
              room_name: room_name,
              room_id: room.id
            }})
          {:error, _} ->
            # Room deletion failed, no-op
            :ok
        end
    end
  end

  defp broadcast_presence_update_to_all(socket, presence_state) do
    user_count = map_size(presence_state)
    broadcast!(socket, "user_count_updated", %{count: user_count, users: presence_state})
  end
end
