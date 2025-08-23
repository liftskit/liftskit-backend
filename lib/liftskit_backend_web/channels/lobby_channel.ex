# We want to see when rooms are deleted -> broadcast to front end the remaining channels
defmodule LiftskitBackendWeb.LobbyChannel do
  use LiftskitBackendWeb, :channel

  alias LiftskitBackend.Rooms

  @impl true
  def join("lobby:lobby", _payload, socket) do
    # Subscribe to lobby topic for room events
    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "lobby:lobby")

    # Trigger after_join to send initial room list
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    # Unsubscribe from PubSub when channel terminates
    Phoenix.PubSub.unsubscribe(LiftskitBackend.PubSub, "lobby:lobby")
    :ok
  end

  @impl true
  def handle_info(:after_join, socket) do
    # Send initial room list when joining lobby
    rooms = Rooms.list_rooms()
    push(socket, "rooms_list", %{rooms: rooms})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:room_deleted, %{room_name: room_name, room_id: room_id}}, socket) do
    # Get updated room list after deletion
    rooms = Rooms.list_rooms()

    # Push updated room list to this client
    push(socket, "rooms_updated", %{rooms: rooms, deleted_room: %{name: room_name, id: room_id}})

    {:noreply, socket}
  end

  @impl true
  def handle_info({:room_created, %{room_name: room_name, room_id: room_id}}, socket) do
    rooms = Rooms.list_rooms()

    # Push updated room list to this client
    push(socket, "rooms_updated", %{rooms: rooms, created_room: %{name: room_name, id: room_id}})

    {:noreply, socket}
  end

  # Handle any broadcasts that might come through
  @impl true
  def handle_out(event, payload, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
