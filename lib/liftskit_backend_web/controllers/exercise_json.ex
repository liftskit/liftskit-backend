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

  defp data(%Scope{} = _scope, %Exercise{} = exercise) do
    %{
      id: exercise.id,
      name: exercise.name,
      _type: exercise._type,
      orm_percent: if(exercise.orm_percent, do: Decimal.to_string(exercise.orm_percent), else: nil),
      reps: exercise.reps,
      sets: exercise.sets,
      time: exercise.time,
      weight: exercise.weight,
      is_superset: exercise.is_superset,
      superset_group: exercise.superset_group,
      superset_order: exercise.superset_order
    }
  end
end
