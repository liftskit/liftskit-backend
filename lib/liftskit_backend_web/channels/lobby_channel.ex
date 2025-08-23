defmodule LiftskitBackendWeb.LobbyChannel do
  alias LiftskitBackend.Rooms
  use LiftskitBackendWeb, :channel

  @impl true
  def join("lobby:lobby", _payload, _socket) do
    # Subscribe to the lobby topic for room events
    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "lobby:lobby")

    # Trigger after_join to send initial room list
    send(self(), :after_lobby)
  end

  @impl true
  def terminate(_reason, _socket) do
    Phoenix.PubSub.unsubscribe(LiftskitBackend.PubSub, "lobby:lobby")
    :ok
  end

  @impl true
  def handle_info(:after_lobby, socket) do
    rooms = Rooms.list_rooms()
    push(socket, "rooms_list", %{rooms: rooms})
    {:noreply, socket}
  end

  def handle_info(:room_created, %{room_name: room_name, room_id: room_id}, socket) do
    rooms = Rooms.list_rooms()

    # Push updated room list to this client
    push(socket, "rooms_updated", %{rooms: rooms, created_room: %{name: room_name, id: room_id}})

    {:noreply, socket}
  end

  def handle_info(:room_deleted, %{room_name: room_name, room_id: room_id}, socket) do
    rooms = Rooms.list_rooms()

    # Push updated room list to this client
    push(socket, "rooms_updated", %{rooms: rooms, created_room: %{name: room_name, id: room_id}})

    {:noreply, socket}
  end

end
