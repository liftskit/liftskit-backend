defmodule LiftskitBackendWeb.ExerciseJSON do
  alias LiftskitBackend.Exercises.Exercise
  alias LiftskitBackend.ExerciseRoots
  alias LiftskitBackend.Accounts.Scope
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
    exercise_root_id = exercise.exerciseRoot
    exercise_root = ExerciseRoots.get_exercise_root!(scope, exercise_root_id)
    %{
      id: exercise.id,
      ormPercent: if(exercise.ormPercent, do: Decimal.to_string(exercise.ormPercent), else: nil),
      reps: exercise.reps,
      sets: exercise.sets,
      time: exercise.time,
      weight: exercise.weight,
      isSuperset: exercise.isSuperset,
      exerciseRoot: %{
        id: exercise_root.id,
        name: exercise_root.name,
        type: exercise_root._type
      }
    }
  end
end
