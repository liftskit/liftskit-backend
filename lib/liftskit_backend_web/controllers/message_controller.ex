defmodule LiftskitBackendWeb.MessageController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Messages

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
    # Authentication is now handled by the plug
    case Messages.create_message(conn.assigns.current_scope, params) do
      {:ok, message} ->
        broadcast_to_receiver(message)
        broadcast_to_sender(message)
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
    # Authentication is now handled by the plug
    case Messages.get_message(conn.assigns.current_scope, id) do
      {:ok, message} ->
        conn
        |> assign(:message, message)
        |> render(:show)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Message not found"})

      {:error, :forbidden} ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Access denied to this message"})
    end
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    # Authentication is now handled by the plug
    case Messages.get_message(conn.assigns.current_scope, id) do
      {:ok, message} ->
        case Messages.update_message(conn.assigns.current_scope, message, message_params) do
          {:ok, message} ->
            conn
            |> assign(:message, message)
            |> render(:show)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Validation failed", details: format_changeset_errors(changeset)})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Message not found"})

      {:error, :forbidden} ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Access denied to this message"})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Messages.get_message(conn.assigns.current_scope, id) do
      {:ok, message} ->
        case Messages.delete_message(conn.assigns.current_scope, message) do
          {:ok, _message} ->
            conn
            |> put_status(:no_content)
            |> send_resp(:no_content, "")

          {:error, _changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Failed to delete message"})
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Message not found"})

      {:error, :forbidden} ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Access denied to this message"})
    end
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp broadcast_to_receiver(message) do
    LiftskitChatWeb.Endpoint.broadcast(
      "user_messages:#{message.to_user.username}",
      "message:received",
      %{
        id: message.id,
        body: message.body,
        created: message.inserted_at,
        from_user_id: message.from_user_id,
        to_user_id: message.to_user_id,
        from_username: message.from_user.username,
        to_username: message.to_user.username
      }
    )
  end

  defp broadcast_to_sender(message) do
    LiftskitChatWeb.Endpoint.broadcast(
      "user_messages:#{message.from_user.username}",
      "message:received",
      %{
        id: message.id,
        body: message.body,
        created: message.inserted_at,
        from_user_id: message.from_user_id,
        to_user_id: message.to_user_id,
        from_username: message.from_user.username,
        to_username: message.to_user.username
      }
    )
  end
end
