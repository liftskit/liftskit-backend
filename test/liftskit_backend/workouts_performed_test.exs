defmodule LiftskitBackend.WorkoutsPerformedTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.WorkoutsPerformed

  describe "workouts_performed" do
    alias LiftskitBackend.WorkoutsPerformed.WorkoutPerformed

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.WorkoutsPerformedFixtures

    @invalid_attrs %{programName: nil, workoutDate: nil, workoutTime: nil, workoutName: nil}

    test "list_workouts_performed/1 returns all scoped workouts_performed" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      other_workout_performed = workout_performed_fixture(other_scope)
      assert WorkoutsPerformed.list_workouts_performed(scope) == [workout_performed]
      assert WorkoutsPerformed.list_workouts_performed(other_scope) == [other_workout_performed]
    end

    test "get_workout_performed!/2 returns the workout_performed with given id" do
      scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      other_scope = user_scope_fixture()
      assert WorkoutsPerformed.get_workout_performed!(scope, workout_performed.id) == workout_performed
      assert_raise Ecto.NoResultsError, fn -> WorkoutsPerformed.get_workout_performed!(other_scope, workout_performed.id) end
    end

    test "create_workout_performed/2 with valid data creates a workout_performed" do
      valid_attrs = %{programName: "some programName", workoutDate: ~U[2025-08-23 18:56:00Z], workoutTime: 42, workoutName: "some workoutName"}
      scope = user_scope_fixture()

      assert {:ok, %WorkoutPerformed{} = workout_performed} = WorkoutsPerformed.create_workout_performed(scope, valid_attrs)
      assert workout_performed.programName == "some programName"
      assert workout_performed.workoutDate == ~U[2025-08-23 18:56:00Z]
      assert workout_performed.workoutTime == 42
      assert workout_performed.workoutName == "some workoutName"
      assert workout_performed.user_id == scope.user.id
    end

    test "create_workout_performed/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkoutsPerformed.create_workout_performed(scope, @invalid_attrs)
    end

    test "update_workout_performed/3 with valid data updates the workout_performed" do
      scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      update_attrs = %{programName: "some updated programName", workoutDate: ~U[2025-08-24 18:56:00Z], workoutTime: 43, workoutName: "some updated workoutName"}

      assert {:ok, %WorkoutPerformed{} = workout_performed} = WorkoutsPerformed.update_workout_performed(scope, workout_performed, update_attrs)
      assert workout_performed.programName == "some updated programName"
      assert workout_performed.workoutDate == ~U[2025-08-24 18:56:00Z]
      assert workout_performed.workoutTime == 43
      assert workout_performed.workoutName == "some updated workoutName"
    end

    test "update_workout_performed/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)

      assert_raise MatchError, fn ->
        WorkoutsPerformed.update_workout_performed(other_scope, workout_performed, %{})
      end
    end

    test "update_workout_performed/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = WorkoutsPerformed.update_workout_performed(scope, workout_performed, @invalid_attrs)
      assert workout_performed == WorkoutsPerformed.get_workout_performed!(scope, workout_performed.id)
    end

    test "delete_workout_performed/2 deletes the workout_performed" do
      scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      assert {:ok, %WorkoutPerformed{}} = WorkoutsPerformed.delete_workout_performed(scope, workout_performed)
      assert_raise Ecto.NoResultsError, fn -> WorkoutsPerformed.get_workout_performed!(scope, workout_performed.id) end
    end

    test "delete_workout_performed/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      assert_raise MatchError, fn -> WorkoutsPerformed.delete_workout_performed(other_scope, workout_performed) end
    end

    test "change_workout_performed/2 returns a workout_performed changeset" do
      scope = user_scope_fixture()
      workout_performed = workout_performed_fixture(scope)
      assert %Ecto.Changeset{} = WorkoutsPerformed.change_workout_performed(scope, workout_performed)
    end
  end
end
