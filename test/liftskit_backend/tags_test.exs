defmodule LiftskitBackend.TagsTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.Tags

  describe "tags" do
    alias LiftskitBackend.Tags.Tag

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.TagsFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/1 returns all scoped tags" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tag = tag_fixture(scope)
      other_tag = tag_fixture(other_scope)
      assert Tags.list_tags(scope) == [tag]
      assert Tags.list_tags(other_scope) == [other_tag]
    end

    test "get_tag!/2 returns the tag with given id" do
      scope = user_scope_fixture()
      tag = tag_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tags.get_tag!(scope, tag.id) == tag
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(other_scope, tag.id) end
    end

    test "create_tag/2 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}
      scope = user_scope_fixture()

      assert {:ok, %Tag{} = tag} = Tags.create_tag(scope, valid_attrs)
      assert tag.name == "some name"
      assert tag.user_id == scope.user.id
    end

    test "create_tag/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag(scope, @invalid_attrs)
    end

    test "update_tag/3 with valid data updates the tag" do
      scope = user_scope_fixture()
      tag = tag_fixture(scope)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Tags.update_tag(scope, tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tag = tag_fixture(scope)

      assert_raise MatchError, fn ->
        Tags.update_tag(other_scope, tag, %{})
      end
    end

    test "update_tag/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      tag = tag_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag(scope, tag, @invalid_attrs)
      assert tag == Tags.get_tag!(scope, tag.id)
    end

    test "delete_tag/2 deletes the tag" do
      scope = user_scope_fixture()
      tag = tag_fixture(scope)
      assert {:ok, %Tag{}} = Tags.delete_tag(scope, tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(scope, tag.id) end
    end

    test "delete_tag/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tag = tag_fixture(scope)
      assert_raise MatchError, fn -> Tags.delete_tag(other_scope, tag) end
    end

    test "change_tag/2 returns a tag changeset" do
      scope = user_scope_fixture()
      tag = tag_fixture(scope)
      assert %Ecto.Changeset{} = Tags.change_tag(scope, tag)
    end
  end
end
