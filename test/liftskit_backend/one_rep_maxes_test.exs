defmodule LiftskitBackend.OneRepMaxesTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.OneRepMaxes

  describe "one-rep-max" do
    alias LiftskitBackend.OneRepMaxes.OneRepMax

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.OneRepMaxesFixtures

    @invalid_attrs %{exerciseName: nil, oneRepMax: nil}

    test "list_one-rep-max/1 returns all scoped one-rep-max" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      other_one_rep_max = one_rep_max_fixture(other_scope)
      assert OneRepMaxes.list_one-rep-max(scope) == [one_rep_max]
      assert OneRepMaxes.list_one-rep-max(other_scope) == [other_one_rep_max]
    end

    test "get_one_rep_max!/2 returns the one_rep_max with given id" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      other_scope = user_scope_fixture()
      assert OneRepMaxes.get_one_rep_max!(scope, one_rep_max.id) == one_rep_max
      assert_raise Ecto.NoResultsError, fn -> OneRepMaxes.get_one_rep_max!(other_scope, one_rep_max.id) end
    end

    test "create_one_rep_max/2 with valid data creates a one_rep_max" do
      valid_attrs = %{exerciseName: "some exerciseName", oneRepMax: 42}
      scope = user_scope_fixture()

      assert {:ok, %OneRepMax{} = one_rep_max} = OneRepMaxes.create_one_rep_max(scope, valid_attrs)
      assert one_rep_max.exerciseName == "some exerciseName"
      assert one_rep_max.oneRepMax == 42
      assert one_rep_max.user_id == scope.user.id
    end

    test "create_one_rep_max/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = OneRepMaxes.create_one_rep_max(scope, @invalid_attrs)
    end

    test "update_one_rep_max/3 with valid data updates the one_rep_max" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      update_attrs = %{exerciseName: "some updated exerciseName", oneRepMax: 43}

      assert {:ok, %OneRepMax{} = one_rep_max} = OneRepMaxes.update_one_rep_max(scope, one_rep_max, update_attrs)
      assert one_rep_max.exerciseName == "some updated exerciseName"
      assert one_rep_max.oneRepMax == 43
    end

    test "update_one_rep_max/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)

      assert_raise MatchError, fn ->
        OneRepMaxes.update_one_rep_max(other_scope, one_rep_max, %{})
      end
    end

    test "update_one_rep_max/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = OneRepMaxes.update_one_rep_max(scope, one_rep_max, @invalid_attrs)
      assert one_rep_max == OneRepMaxes.get_one_rep_max!(scope, one_rep_max.id)
    end

    test "delete_one_rep_max/2 deletes the one_rep_max" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert {:ok, %OneRepMax{}} = OneRepMaxes.delete_one_rep_max(scope, one_rep_max)
      assert_raise Ecto.NoResultsError, fn -> OneRepMaxes.get_one_rep_max!(scope, one_rep_max.id) end
    end

    test "delete_one_rep_max/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert_raise MatchError, fn -> OneRepMaxes.delete_one_rep_max(other_scope, one_rep_max) end
    end

    test "change_one_rep_max/2 returns a one_rep_max changeset" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert %Ecto.Changeset{} = OneRepMaxes.change_one_rep_max(scope, one_rep_max)
    end
  end

  describe "one_rep_max" do
    alias LiftskitBackend.OneRepMaxes.OneRepMax

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.OneRepMaxesFixtures

    @invalid_attrs %{exerciseName: nil, oneRepMax: nil}

    test "list_one_rep_max/1 returns all scoped one_rep_max" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      other_one_rep_max = one_rep_max_fixture(other_scope)
      assert OneRepMaxes.list_one_rep_max(scope) == [one_rep_max]
      assert OneRepMaxes.list_one_rep_max(other_scope) == [other_one_rep_max]
    end

    test "get_one_rep_max!/2 returns the one_rep_max with given id" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      other_scope = user_scope_fixture()
      assert OneRepMaxes.get_one_rep_max!(scope, one_rep_max.id) == one_rep_max
      assert_raise Ecto.NoResultsError, fn -> OneRepMaxes.get_one_rep_max!(other_scope, one_rep_max.id) end
    end

    test "create_one_rep_max/2 with valid data creates a one_rep_max" do
      valid_attrs = %{exerciseName: "some exerciseName", oneRepMax: 42}
      scope = user_scope_fixture()

      assert {:ok, %OneRepMax{} = one_rep_max} = OneRepMaxes.create_one_rep_max(scope, valid_attrs)
      assert one_rep_max.exerciseName == "some exerciseName"
      assert one_rep_max.oneRepMax == 42
      assert one_rep_max.user_id == scope.user.id
    end

    test "create_one_rep_max/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = OneRepMaxes.create_one_rep_max(scope, @invalid_attrs)
    end

    test "update_one_rep_max/3 with valid data updates the one_rep_max" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      update_attrs = %{exerciseName: "some updated exerciseName", oneRepMax: 43}

      assert {:ok, %OneRepMax{} = one_rep_max} = OneRepMaxes.update_one_rep_max(scope, one_rep_max, update_attrs)
      assert one_rep_max.exerciseName == "some updated exerciseName"
      assert one_rep_max.oneRepMax == 43
    end

    test "update_one_rep_max/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)

      assert_raise MatchError, fn ->
        OneRepMaxes.update_one_rep_max(other_scope, one_rep_max, %{})
      end
    end

    test "update_one_rep_max/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = OneRepMaxes.update_one_rep_max(scope, one_rep_max, @invalid_attrs)
      assert one_rep_max == OneRepMaxes.get_one_rep_max!(scope, one_rep_max.id)
    end

    test "delete_one_rep_max/2 deletes the one_rep_max" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert {:ok, %OneRepMax{}} = OneRepMaxes.delete_one_rep_max(scope, one_rep_max)
      assert_raise Ecto.NoResultsError, fn -> OneRepMaxes.get_one_rep_max!(scope, one_rep_max.id) end
    end

    test "delete_one_rep_max/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert_raise MatchError, fn -> OneRepMaxes.delete_one_rep_max(other_scope, one_rep_max) end
    end

    test "change_one_rep_max/2 returns a one_rep_max changeset" do
      scope = user_scope_fixture()
      one_rep_max = one_rep_max_fixture(scope)
      assert %Ecto.Changeset{} = OneRepMaxes.change_one_rep_max(scope, one_rep_max)
    end
  end
end
