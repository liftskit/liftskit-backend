defmodule LiftskitBackend.MessagesTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.Messages

  describe "messages" do
    alias LiftskitBackend.Messages.Message

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.MessagesFixtures

    @invalid_attrs %{body: nil, created: nil}

    test "list_messages/1 returns all scoped messages" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      message = message_fixture(scope)
      other_message = message_fixture(other_scope)
      assert Messages.list_messages(scope) == [message]
      assert Messages.list_messages(other_scope) == [other_message]
    end

    test "get_message!/2 returns the message with given id" do
      scope = user_scope_fixture()
      message = message_fixture(scope)
      other_scope = user_scope_fixture()
      assert Messages.get_message!(scope, message.id) == message
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(other_scope, message.id) end
    end

    test "create_message/2 with valid data creates a message" do
      valid_attrs = %{body: "some body", created: ~U[2025-08-20 01:30:00Z]}
      scope = user_scope_fixture()

      assert {:ok, %Message{} = message} = Messages.create_message(scope, valid_attrs)
      assert message.body == "some body"
      assert message.created == ~U[2025-08-20 01:30:00Z]
      assert message.user_id == scope.user.id
    end

    test "create_message/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(scope, @invalid_attrs)
    end

    test "update_message/3 with valid data updates the message" do
      scope = user_scope_fixture()
      message = message_fixture(scope)
      update_attrs = %{body: "some updated body", created: ~U[2025-08-21 01:30:00Z]}

      assert {:ok, %Message{} = message} = Messages.update_message(scope, message, update_attrs)
      assert message.body == "some updated body"
      assert message.created == ~U[2025-08-21 01:30:00Z]
    end

    test "update_message/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      message = message_fixture(scope)

      assert_raise MatchError, fn ->
        Messages.update_message(other_scope, message, %{})
      end
    end

    test "update_message/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      message = message_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(scope, message, @invalid_attrs)
      assert message == Messages.get_message!(scope, message.id)
    end

    test "delete_message/2 deletes the message" do
      scope = user_scope_fixture()
      message = message_fixture(scope)
      assert {:ok, %Message{}} = Messages.delete_message(scope, message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(scope, message.id) end
    end

    test "delete_message/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      message = message_fixture(scope)
      assert_raise MatchError, fn -> Messages.delete_message(other_scope, message) end
    end

    test "change_message/2 returns a message changeset" do
      scope = user_scope_fixture()
      message = message_fixture(scope)
      assert %Ecto.Changeset{} = Messages.change_message(scope, message)
    end
  end
end
