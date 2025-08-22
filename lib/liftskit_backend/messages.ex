defmodule LiftskitBackend.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Messages.Message
  alias LiftskitBackend.Accounts.Scope
  alias LiftskitBackend.Accounts.User

  @doc """
  Subscribes to scoped notifications about any message changes.

  The broadcasted messages match the pattern:

    * {:created, %Message{}}
    * {:updated, %Message{}}
    * {:deleted, %Message{}}

  """
  def subscribe_messages(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:messages")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:messages", message)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages(scope)
      [%Message{}, ...]

  """
  def list_messages(%Scope{} = scope) do
    Repo.all(
      from m in Message,
      where: m.from_user_id == ^scope.user.id or m.to_user_id == ^scope.user.id,
      order_by: [asc: m.inserted_at],
      preload: [:from_user, :to_user]
    )
  end

  @doc """
  Gets a single message.

  Returns `{:ok, message}` if found and accessible, or `{:error, reason}` if not.

  ## Examples

      iex> get_message(scope, 123)
      {:ok, %Message{}}

      iex> get_message(scope, 456)
      {:error, :not_found}

  """
  def get_message(%Scope{} = scope, id) do
    case Repo.get_by(Message, id: id) do
      nil ->
        {:error, :not_found}

      message ->
        message_with_users = Repo.preload(message, [:from_user, :to_user])
        if message_with_users.from_user_id == scope.user.id or message_with_users.to_user_id == scope.user.id do
          {:ok, message_with_users}
        else
          {:error, :forbidden}
        end
    end
  end

    @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(%Scope{} = scope, id) do
    case get_message(scope, id) do
      {:ok, message} -> message
      {:error, :not_found} -> raise Ecto.NoResultsError, queryable: Message
      {:error, :forbidden} -> raise Ecto.NoResultsError, queryable: Message
    end
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(%Scope{} = scope, attrs) do
    with {:ok, message = %Message{}} <-
           %Message{}
           |> Message.changeset(attrs, scope)
           |> Repo.insert() do
      message_with_users = Repo.preload(message, [:from_user, :to_user])
      broadcast(scope, {:created, message_with_users})
      {:ok, message_with_users}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(scope, message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(scope, message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Scope{} = scope, %Message{} = message, attrs) do
    true = message.user_id == scope.user.id

    with {:ok, message = %Message{}} <-
           message
           |> Message.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, message})
      {:ok, message}
    end
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(scope, message)
      {:ok, %Message{}}

      iex> delete_message(scope, message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Scope{} = scope, %Message{} = message) do
    true = message.from_user_id == scope.user.id

    with {:ok, message = %Message{}} <-
           Repo.delete(message) do
      broadcast(scope, {:deleted, message})
      {:ok, message}
    end
  end

  @doc """
  Gets the list of all conversations for a user. Only returns the last message in each conversation.

  ## Examples

      iex> get_conversations(scope)
      [%Message{}, ...]

  """
  def change_message(%Scope{} = scope, %Message{} = message, attrs \\ %{}) do
    true = message.user_id == scope.user.id

    Message.changeset(message, attrs, scope)
  end

  def get_conversations(%Scope{} = scope) do
    other_user_ids = Repo.all(
      from m in Message,
      where: m.from_user_id == ^scope.user.id,
      select: m.to_user_id
    ) ++
    Repo.all(
      from m in Message,
      where: m.to_user_id == ^scope.user.id,
      select: m.from_user_id
    )
    |> Enum.uniq()


    other_users = Repo.all(from u in User, where: u.id in ^other_user_ids)

    Enum.map(other_users, fn other_user ->
      Repo.one(
        from m in Message,
        where: (m.from_user_id == ^scope.user.id and m.to_user_id == ^other_user.id) or
               (m.from_user_id == ^other_user.id and m.to_user_id == ^scope.user.id),
        order_by: [desc: m.inserted_at],
        limit: 1,
        preload: [:from_user, :to_user]
      )
    end)
    |> Enum.reject(&is_nil/1)

  end

  @doc """
  Gets all messages between the current user and a specific other user (a conversation).

  ## Examples

      iex> get_conversation_with_user(scope, 123)
      [%Message{}, ...]

  """
  def get_conversation_with_user(%Scope{} = scope, other_user_id) do
    Repo.all(
      from m in Message,
      where: (m.from_user_id == ^scope.user.id and m.to_user_id == ^other_user_id) or
             (m.from_user_id == ^other_user_id and m.to_user_id == ^scope.user.id),
      order_by: [asc: m.inserted_at],
      preload: [:from_user, :to_user]
    )
  end

  @doc """
  Gets messages sent by a user.

  ## Examples

      iex> get_sent_messages(scope)
      [%Message{}, ...]

  """
  def get_sent_messages(%Scope{} = scope) do
    Repo.all(
      from m in Message,
      where: m.from_user_id == ^scope.user.id,
      order_by: [desc: m.inserted_at],
      preload: [:to_user]
    )
  end

  @doc """
  Gets messages received by a user.

  ## Examples

      iex> get_received_messages(scope)
      [%Message{}, ...]

  """
  def get_received_messages(%Scope{} = scope) do
    Repo.all(
      from m in Message,
      where: m.to_user_id == ^scope.user.id,
      order_by: [desc: m.inserted_at],
      preload: [:from_user]
    )
  end
end
