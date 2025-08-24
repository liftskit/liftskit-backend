defmodule LiftskitBackend.ExercisesTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.Exercises

  describe "exercises" do
    alias LiftskitBackend.Exercises.Exercise

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.ExercisesFixtures

    @invalid_attrs %{time: nil, sets: nil, ormPercent: nil, reps: nil, weight: nil, isSuperset: nil}

    test "list_exercises/1 returns all scoped exercises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      other_exercise = exercise_fixture(other_scope)
      assert Exercises.list_exercises(scope) == [exercise]
      assert Exercises.list_exercises(other_scope) == [other_exercise]
    end

    test "get_exercise!/2 returns the exercise with given id" do
      scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      other_scope = user_scope_fixture()
      assert Exercises.get_exercise!(scope, exercise.id) == exercise
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_exercise!(other_scope, exercise.id) end
    end

    test "create_exercise/2 with valid data creates a exercise" do
      valid_attrs = %{time: "some time", sets: 42, ormPercent: "120.5", reps: 42, weight: 42, isSuperset: true}
      scope = user_scope_fixture()

      assert {:ok, %Exercise{} = exercise} = Exercises.create_exercise(scope, valid_attrs)
      assert exercise.time == "some time"
      assert exercise.sets == 42
      assert exercise.ormPercent == Decimal.new("120.5")
      assert exercise.reps == 42
      assert exercise.weight == 42
      assert exercise.isSuperset == true
      assert exercise.user_id == scope.user.id
    end

    test "create_exercise/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.create_exercise(scope, @invalid_attrs)
    end

    test "update_exercise/3 with valid data updates the exercise" do
      scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      update_attrs = %{time: "some updated time", sets: 43, ormPercent: "456.7", reps: 43, weight: 43, isSuperset: false}

      assert {:ok, %Exercise{} = exercise} = Exercises.update_exercise(scope, exercise, update_attrs)
      assert exercise.time == "some updated time"
      assert exercise.sets == 43
      assert exercise.ormPercent == Decimal.new("456.7")
      assert exercise.reps == 43
      assert exercise.weight == 43
      assert exercise.isSuperset == false
    end

    test "update_exercise/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise = exercise_fixture(scope)

      assert_raise MatchError, fn ->
        Exercises.update_exercise(other_scope, exercise, %{})
      end
    end

    test "update_exercise/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Exercises.update_exercise(scope, exercise, @invalid_attrs)
      assert exercise == Exercises.get_exercise!(scope, exercise.id)
    end

    test "delete_exercise/2 deletes the exercise" do
      scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      assert {:ok, %Exercise{}} = Exercises.delete_exercise(scope, exercise)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_exercise!(scope, exercise.id) end
    end

    test "delete_exercise/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      assert_raise MatchError, fn -> Exercises.delete_exercise(other_scope, exercise) end
    end

    test "change_exercise/2 returns a exercise changeset" do
      scope = user_scope_fixture()
      exercise = exercise_fixture(scope)
      assert %Ecto.Changeset{} = Exercises.change_exercise(scope, exercise)
    end
  end
end
