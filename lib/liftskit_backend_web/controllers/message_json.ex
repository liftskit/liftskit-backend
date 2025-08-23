defmodule LiftskitBackendWeb.MessageJSON do
  alias LiftskitBackend.Messages.Message

  @doc """
  Renders a list of messages.
  """
  def index(%{messages: messages}) do
    %{data: for(message <- messages, do: data(message))}
  end

  @doc """
  Renders a single message.
  """
  @spec show(%{message: %LiftskitBackend.Messages.Message{}}) :: %{
    data: %{
      created: any(),
      from_user_id: any(),
      from_username: any(),
      id: any(),
      to_user_id: any(),
      to_username: any(),
      body: any()
    }
  }
  def show(%{message: message}) do
    %{data: data(message)}
  end

  def create(%{message: message}) do
    %{data: data(message)}
  end

  def delete(%{message: _message}) do
    %{data: %{status: "deleted"}}
  end

  defp data(%Message{} = message) do
    %{
      id: message.id,
      body: message.body,
      created: message.created,
      from_user_id: message.from_user_id,
      to_user_id: message.to_user_id,
      from_username: message.from_user.username,
      to_username: message.to_user.username
    }
  end
end
