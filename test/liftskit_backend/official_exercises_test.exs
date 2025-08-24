defmodule LiftskitBackend.OfficialExercisesTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.OfficialExercises

  describe "official_exercises" do
    alias LiftskitBackend.OfficialExercises.OfficialExercise

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.OfficialExercisesFixtures

    @invalid_attrs %{name: nil}

    test "list_official_exercises/1 returns all scoped official_exercises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      other_official_exercise = official_exercise_fixture(other_scope)
      assert OfficialExercises.list_official_exercises(scope) == [official_exercise]
      assert OfficialExercises.list_official_exercises(other_scope) == [other_official_exercise]
    end

    test "get_official_exercise!/2 returns the official_exercise with given id" do
      scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      other_scope = user_scope_fixture()
      assert OfficialExercises.get_official_exercise!(scope, official_exercise.id) == official_exercise
      assert_raise Ecto.NoResultsError, fn -> OfficialExercises.get_official_exercise!(other_scope, official_exercise.id) end
    end

    test "create_official_exercise/2 with valid data creates a official_exercise" do
      valid_attrs = %{name: "some name"}
      scope = user_scope_fixture()

      assert {:ok, %OfficialExercise{} = official_exercise} = OfficialExercises.create_official_exercise(scope, valid_attrs)
      assert official_exercise.name == "some name"
      assert official_exercise.user_id == scope.user.id
    end

    test "create_official_exercise/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = OfficialExercises.create_official_exercise(scope, @invalid_attrs)
    end

    test "update_official_exercise/3 with valid data updates the official_exercise" do
      scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %OfficialExercise{} = official_exercise} = OfficialExercises.update_official_exercise(scope, official_exercise, update_attrs)
      assert official_exercise.name == "some updated name"
    end

    test "update_official_exercise/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)

      assert_raise MatchError, fn ->
        OfficialExercises.update_official_exercise(other_scope, official_exercise, %{})
      end
    end

    test "update_official_exercise/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = OfficialExercises.update_official_exercise(scope, official_exercise, @invalid_attrs)
      assert official_exercise == OfficialExercises.get_official_exercise!(scope, official_exercise.id)
    end

    test "delete_official_exercise/2 deletes the official_exercise" do
      scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      assert {:ok, %OfficialExercise{}} = OfficialExercises.delete_official_exercise(scope, official_exercise)
      assert_raise Ecto.NoResultsError, fn -> OfficialExercises.get_official_exercise!(scope, official_exercise.id) end
    end

    test "delete_official_exercise/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      assert_raise MatchError, fn -> OfficialExercises.delete_official_exercise(other_scope, official_exercise) end
    end

    test "change_official_exercise/2 returns a official_exercise changeset" do
      scope = user_scope_fixture()
      official_exercise = official_exercise_fixture(scope)
      assert %Ecto.Changeset{} = OfficialExercises.change_official_exercise(scope, official_exercise)
    end
  end
end
