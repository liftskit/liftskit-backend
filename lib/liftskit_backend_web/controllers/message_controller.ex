defmodule LiftskitBackendWeb.MessageController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Messages
  alias LiftskitBackend.Messages.Message

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    conversations = Messages.get_conversations(conn.assigns.current_scope)
    conn
    |> assign(:messages, conversations)
    |> render(:index)
  end

  def conversations_with_user(conn, %{"user_id" => user_id}) do
    messages = Messages.get_conversation_with_user(conn.assigns.current_scope, String.to_integer(user_id))

    conn
    |> assign(:messages, messages)
    |> render(:index)
  end

  def create(conn, params) do
    # Authentication is handled by the plug
    case Messages.create_message(conn.assigns.current_scope, params) do
      {:ok, message} ->
        broadcast_to_user(message, message.to_user.username)
        broadcast_to_user(message, message.from_user.username)
        conn
        |> put_status(:created)
        |> assign(:message, message)
        |> render(:show)

        {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Validation failed", details: format_changeset_errors(changeset)})
    end
  end

  def show(conn, %{"id" => id}) do
    message = Messages.get_message!(conn.assigns.current_scope, id)
    render(conn, :show, message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Messages.get_message!(conn.assigns.current_scope, id)

    with {:ok, %Message{} = message} <- Messages.update_message(conn.assigns.current_scope, message, message_params) do
      render(conn, :show, message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Messages.get_message!(conn.assigns.current_scope, id)

    with {:ok, %Message{}} <- Messages.delete_message(conn.assigns.current_scope, message) do
      send_resp(conn, :no_content, "")
    end
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp broadcast_to_user(message, receiver_username) do
      LiftskitBackendWeb.Endpoint.broadcast(
        "user_messages:#{receiver_username}",
        "message:received",
        %{
          id: message.id,
          body: message.body,
          created: message.inserted_at,
          from_user_id: message.from_user_id,
          to_user_id: message.to_user_id,
          from_username: message.from_user.username,
          to_username: message.to_user.username,

        }
      )
  end
end
