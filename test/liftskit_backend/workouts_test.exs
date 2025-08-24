defmodule LiftskitBackend.WorkoutsTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.Workouts

  describe "workouts" do
    alias LiftskitBackend.Workouts.Workout

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.WorkoutsFixtures

    @invalid_attrs %{name: nil, bestWorkoutTime: nil}

    test "list_workouts/1 returns all scoped workouts" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      workout = workout_fixture(scope)
      other_workout = workout_fixture(other_scope)
      assert Workouts.list_workouts(scope) == [workout]
      assert Workouts.list_workouts(other_scope) == [other_workout]
    end

    test "get_workout!/2 returns the workout with given id" do
      scope = user_scope_fixture()
      workout = workout_fixture(scope)
      other_scope = user_scope_fixture()
      assert Workouts.get_workout!(scope, workout.id) == workout
      assert_raise Ecto.NoResultsError, fn -> Workouts.get_workout!(other_scope, workout.id) end
    end

    test "create_workout/2 with valid data creates a workout" do
      valid_attrs = %{name: "some name", bestWorkoutTime: "some bestWorkoutTime"}
      scope = user_scope_fixture()

      assert {:ok, %Workout{} = workout} = Workouts.create_workout(scope, valid_attrs)
      assert workout.name == "some name"
      assert workout.bestWorkoutTime == "some bestWorkoutTime"
      assert workout.user_id == scope.user.id
    end

    test "create_workout/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Workouts.create_workout(scope, @invalid_attrs)
    end

    test "update_workout/3 with valid data updates the workout" do
      scope = user_scope_fixture()
      workout = workout_fixture(scope)
      update_attrs = %{name: "some updated name", bestWorkoutTime: "some updated bestWorkoutTime"}

      assert {:ok, %Workout{} = workout} = Workouts.update_workout(scope, workout, update_attrs)
      assert workout.name == "some updated name"
      assert workout.bestWorkoutTime == "some updated bestWorkoutTime"
    end

    test "update_workout/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      workout = workout_fixture(scope)

      assert_raise MatchError, fn ->
        Workouts.update_workout(other_scope, workout, %{})
      end
    end

    test "update_workout/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      workout = workout_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Workouts.update_workout(scope, workout, @invalid_attrs)
      assert workout == Workouts.get_workout!(scope, workout.id)
    end

    test "delete_workout/2 deletes the workout" do
      scope = user_scope_fixture()
      workout = workout_fixture(scope)
      assert {:ok, %Workout{}} = Workouts.delete_workout(scope, workout)
      assert_raise Ecto.NoResultsError, fn -> Workouts.get_workout!(scope, workout.id) end
    end

    test "delete_workout/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      workout = workout_fixture(scope)
      assert_raise MatchError, fn -> Workouts.delete_workout(other_scope, workout) end
    end

    test "change_workout/2 returns a workout changeset" do
      scope = user_scope_fixture()
      workout = workout_fixture(scope)
      assert %Ecto.Changeset{} = Workouts.change_workout(scope, workout)
    end
  end
end
