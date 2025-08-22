defmodule LiftskitBackend.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiftskitBackend.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        body: "some body",
        created: ~U[2025-08-20 01:30:00Z]
      })

    {:ok, message} = LiftskitBackend.Messages.create_message(scope, attrs)
    message
  end
end
