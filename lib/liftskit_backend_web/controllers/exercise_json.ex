defmodule LiftskitBackendWeb.ExerciseJSON do
  alias LiftskitBackend.Exercises.Exercise
  alias LiftskitBackend.ExerciseRoots
  alias LiftskitBackend.Accounts.Scope
  alias LiftskitBackend.Exercises
  alias Decimal

  @doc """
  Renders a list of exercises.
  """
  def index(%{scope: scope, exercises: exercises}) do
    %{data: for(exercise <- exercises, do: data(scope, exercise))}
  end

  # Add a fallback clause for the current structure with current_scope and current_user
  def index(%{current_scope: scope, current_user: _user, exercises: exercises}) do
    %{data: for(exercise <- exercises, do: data(scope, exercise))}
  end

  @doc """
  Renders a single exercise.
  """
  def show(%{scope: scope, exercise: exercise}) do
    %{data: data(scope, exercise)}
  end

  # Add a fallback clause for the current structure with current_scope and current_user
  def show(%{current_scope: scope, current_user: _user, exercise: exercise}) do
    %{data: data(scope, exercise)}
  end

  defp data(%Scope{} = scope, %Exercise{} = exercise) do
    exercise_root_id = exercise.exercise_root_id
    exercise_root = ExerciseRoots.get_exercise_root!(scope, exercise_root_id)
    superset_exercises = Exercises.get_superset_exercises!(scope, exercise.id)
    %{
      id: exercise.id,
      orm_percent: if(exercise.orm_percent, do: Decimal.to_string(exercise.orm_percent), else: nil),
      reps: exercise.reps,
      sets: exercise.sets,
      time: exercise.time,
      weight: exercise.weight,
      is_superset: exercise.is_superset,
      exercise_root: %{
        id: exercise_root.id,
        name: exercise_root.name,
        type: exercise_root._type
      },
      superset_exercises: for(superset_exercise <- superset_exercises, do: superset_exercise_data(scope, superset_exercise))
    }
  end

  defp superset_exercise_data(scope, superset_exercise) do
    exercise_root_id = superset_exercise.exercise_root_id
    exercise_root = ExerciseRoots.get_exercise_root!(scope, exercise_root_id)
    %{
      id: superset_exercise.id,
      orm_percent: if(superset_exercise.orm_percent, do: Decimal.to_string(superset_exercise.orm_percent), else: nil),
      reps: superset_exercise.reps,
      sets: superset_exercise.sets,
      time: superset_exercise.time,
      weight: superset_exercise.weight,
      is_superset: superset_exercise.is_superset,
      exercise_root: %{
        id: exercise_root.id,
        name: exercise_root.name,
        type: exercise_root._type
      }
    }
  end
end
