defmodule LiftskitBackend.ExerciseRootsTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.ExerciseRoots

  describe "exercise_roots" do
    alias LiftskitBackend.ExerciseRoots.ExerciseRoot

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.ExerciseRootsFixtures

    @invalid_attrs %{name: nil, _type: nil}

    test "list_exercise_roots/1 returns all scoped exercise_roots" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      other_exercise_root = exercise_root_fixture(other_scope)
      assert ExerciseRoots.list_exercise_roots(scope) == [exercise_root]
      assert ExerciseRoots.list_exercise_roots(other_scope) == [other_exercise_root]
    end

    test "get_exercise_root!/2 returns the exercise_root with given id" do
      scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      other_scope = user_scope_fixture()
      assert ExerciseRoots.get_exercise_root!(scope, exercise_root.id) == exercise_root
      assert_raise Ecto.NoResultsError, fn -> ExerciseRoots.get_exercise_root!(other_scope, exercise_root.id) end
    end

    test "create_exercise_root/2 with valid data creates a exercise_root" do
      valid_attrs = %{name: "some name", _type: :required}
      scope = user_scope_fixture()

      assert {:ok, %ExerciseRoot{} = exercise_root} = ExerciseRoots.create_exercise_root(scope, valid_attrs)
      assert exercise_root.name == "some name"
      assert exercise_root._type == :required
      assert exercise_root.user_id == scope.user.id
    end

    test "create_exercise_root/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ExerciseRoots.create_exercise_root(scope, @invalid_attrs)
    end

    test "update_exercise_root/3 with valid data updates the exercise_root" do
      scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      update_attrs = %{name: "some updated name", _type: :required}

      assert {:ok, %ExerciseRoot{} = exercise_root} = ExerciseRoots.update_exercise_root(scope, exercise_root, update_attrs)
      assert exercise_root.name == "some updated name"
      assert exercise_root._type == :required
    end

    test "update_exercise_root/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)

      assert_raise MatchError, fn ->
        ExerciseRoots.update_exercise_root(other_scope, exercise_root, %{})
      end
    end

    test "update_exercise_root/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = ExerciseRoots.update_exercise_root(scope, exercise_root, @invalid_attrs)
      assert exercise_root == ExerciseRoots.get_exercise_root!(scope, exercise_root.id)
    end

    test "delete_exercise_root/2 deletes the exercise_root" do
      scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      assert {:ok, %ExerciseRoot{}} = ExerciseRoots.delete_exercise_root(scope, exercise_root)
      assert_raise Ecto.NoResultsError, fn -> ExerciseRoots.get_exercise_root!(scope, exercise_root.id) end
    end

    test "delete_exercise_root/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      assert_raise MatchError, fn -> ExerciseRoots.delete_exercise_root(other_scope, exercise_root) end
    end

    test "change_exercise_root/2 returns a exercise_root changeset" do
      scope = user_scope_fixture()
      exercise_root = exercise_root_fixture(scope)
      assert %Ecto.Changeset{} = ExerciseRoots.change_exercise_root(scope, exercise_root)
    end
  end
end
