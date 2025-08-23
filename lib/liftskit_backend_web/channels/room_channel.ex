defmodule LiftskitBackendWeb.RoomChannel do
  use LiftskitBackendWeb, :channel

  alias Phoenix.Presence
  alias LiftskitBackend.Rooms
  alias LiftskitBackendWeb.Presence

  @impl true
  def join("room:" <> room_name, payload, socket) do
    # Extract username from payload and assign to socket
    username = Map.get(payload, "username", "Anonymous")
    socket = assign(socket, :user, username)
    socket = assign(socket, :room, room_name)

    # Trigger after_join to handle presence tracking and notifications
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_in("new_msg", %{"body" => message, "username" => username}, socket) do
    broadcast!(socket, "new_msg", %{
      body: message,
      user: username
    })
    {:noreply, socket}
  end

  @impl true
  def handle_in("leave_room", _payload, socket) do
    # Get current presence state before removing the user
    presence_state = Presence.list(socket.topic)
    current_user_count = map_size(presence_state)

    # Step 1: Remove the user from presence tracking
    Presence.untrack(socket, socket.assigns.user)

    # Step 2: Calculate the new count (current count minus 1 for the leaving user)
    new_user_count = current_user_count - 1

    # Step 3: Broadcast updated count to all users in the room
    broadcast!(socket, "user_count_updated", %{count: new_user_count, users: presence_state})

    # Check if room is now empty and clean up if needed
    case new_user_count do
      0 ->
        delete_empty_room(socket.assigns.room)
        {:noreply, socket}
      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def terminate(_reason, socket) do

    # Check if this was the last user in the room
    presence_state = Presence.list(socket.topic)
    remaining_users = map_size(presence_state)

    # If this was the last user, clean up the room immediately
    if remaining_users <= 1 do
      delete_empty_room(socket.assigns.room)
    end

    :ok
  end

  @impl true
  def handle_info(:after_join, socket) do
    # Step 1: Track the new user's presence in this room
    {:ok, _} =
      Presence.track(socket, socket.assigns.user, %{
        online_at: inspect(System.system_time(:second))
      })

    # Step 2: Get the updated presence state (includes all users)
    presence_state = Presence.list(socket.topic)

    # Step 3: Send initial state to the joining user
    broadcast_presence_update(socket, presence_state)

    # Step 4: Broadcast updated count to all existing users in the room
    broadcast_presence_update_to_all(socket, presence_state)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_leave, socket) do
    # Step 1: Remove the user from presence tracking
    Presence.untrack(socket, socket.assigns.user)

    # Step 2: Manually broadcast updated count to all users in the room
    presence_state = Presence.list(socket.topic)
    broadcast_presence_update_to_all(socket, presence_state)

    # Check if room is now empty and clean up if needed
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
        # Room doesn't exist in database, nothing to delete
        :ok
      room ->
        case Rooms.delete_room(room.id) do
          {:ok, _deleted_room} ->
            # Send room deletion event to lobby channel
            Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "lobby:lobby", {:room_deleted, %{
              room_name: room_name,
              room_id: room.id
            }})
          {:error, _} ->
            # Room deletion failed, but we don't need to log this in production
            :ok
        end
    end
  end

  defp broadcast_presence_update(socket, presence_state) do
    user_count = map_size(presence_state)
    push(socket, "presence_state", presence_state)
    push(socket, "user_count_updated", %{count: user_count, users: presence_state})
  end

  defp broadcast_presence_update_to_all(socket, presence_state) do
    user_count = map_size(presence_state)
    broadcast!(socket, "user_count_updated", %{count: user_count, users: presence_state})
  end
end
