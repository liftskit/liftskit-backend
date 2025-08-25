defmodule LiftskitBackend.ExercisesPerformedTest do
  use LiftskitBackend.DataCase

  alias LiftskitBackend.ExercisesPerformed

  describe "exercise_performed" do
    alias LiftskitBackend.ExercisesPerformed.ExercisePerformed

    import LiftskitBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import LiftskitBackend.ExercisesPerformedFixtures

    @invalid_attrs %{name: nil, time: nil, sets: nil, _type: nil, reps: nil, weight: nil}

    test "list_exercise_performed/1 returns all scoped exercise_performed" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      other_exercise_performed = exercise_performed_fixture(other_scope)
      assert ExercisesPerformed.list_exercise_performed(scope) == [exercise_performed]
      assert ExercisesPerformed.list_exercise_performed(other_scope) == [other_exercise_performed]
    end

    test "get_exercise_performed!/2 returns the exercise_performed with given id" do
      scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      other_scope = user_scope_fixture()
      assert ExercisesPerformed.get_exercise_performed!(scope, exercise_performed.id) == exercise_performed
      assert_raise Ecto.NoResultsError, fn -> ExercisesPerformed.get_exercise_performed!(other_scope, exercise_performed.id) end
    end

    test "create_exercise_performed/2 with valid data creates a exercise_performed" do
      valid_attrs = %{name: "some name", time: "some time", sets: 42, _type: :strength, reps: 42, weight: 42}
      scope = user_scope_fixture()

      assert {:ok, %ExercisePerformed{} = exercise_performed} = ExercisesPerformed.create_exercise_performed(scope, valid_attrs)
      assert exercise_performed.name == "some name"
      assert exercise_performed.time == "some time"
      assert exercise_performed.sets == 42
      assert exercise_performed._type == :strength
      assert exercise_performed.reps == 42
      assert exercise_performed.weight == 42
      assert exercise_performed.user_id == scope.user.id
    end

    test "create_exercise_performed/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ExercisesPerformed.create_exercise_performed(scope, @invalid_attrs)
    end

    test "update_exercise_performed/3 with valid data updates the exercise_performed" do
      scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      update_attrs = %{name: "some updated name", time: "some updated time", sets: 43, _type: :bodyweight, reps: 43, weight: 43}

      assert {:ok, %ExercisePerformed{} = exercise_performed} = ExercisesPerformed.update_exercise_performed(scope, exercise_performed, update_attrs)
      assert exercise_performed.name == "some updated name"
      assert exercise_performed.time == "some updated time"
      assert exercise_performed.sets == 43
      assert exercise_performed._type == :bodyweight
      assert exercise_performed.reps == 43
      assert exercise_performed.weight == 43
    end

    test "update_exercise_performed/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)

      assert_raise MatchError, fn ->
        ExercisesPerformed.update_exercise_performed(other_scope, exercise_performed, %{})
      end
    end

    test "update_exercise_performed/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = ExercisesPerformed.update_exercise_performed(scope, exercise_performed, @invalid_attrs)
      assert exercise_performed == ExercisesPerformed.get_exercise_performed!(scope, exercise_performed.id)
    end

    test "delete_exercise_performed/2 deletes the exercise_performed" do
      scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      assert {:ok, %ExercisePerformed{}} = ExercisesPerformed.delete_exercise_performed(scope, exercise_performed)
      assert_raise Ecto.NoResultsError, fn -> ExercisesPerformed.get_exercise_performed!(scope, exercise_performed.id) end
    end

    test "delete_exercise_performed/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      assert_raise MatchError, fn -> ExercisesPerformed.delete_exercise_performed(other_scope, exercise_performed) end
    end

    test "change_exercise_performed/2 returns a exercise_performed changeset" do
      scope = user_scope_fixture()
      exercise_performed = exercise_performed_fixture(scope)
      assert %Ecto.Changeset{} = ExercisesPerformed.change_exercise_performed(scope, exercise_performed)
    end
  end
end
