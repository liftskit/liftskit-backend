defmodule LiftskitBackendWeb.MessagesChannel do
  use LiftskitBackendWeb, :channel

  @impl true
  def join("user_messages:" <> username, _payload, socket) do
    if authorized?(socket, username) do
      {:ok, assign(socket, :username, username)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("message:send", %{"body" => body, "to" => to_user}, socket) do
    from_username = socket.assigns.current_user.username
    topic = "user_messages:#{to_user}"

    broadcast(topic, "message:received", %{
      from: from_username,
      body: body,
      timestamp: DateTime.utc_now()
    })

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket, username) do
    socket.assigns.current_user.username == username
  end
end
