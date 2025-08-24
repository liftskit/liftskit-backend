defmodule LiftskitBackendWeb.ExerciseRootJSON do
  alias LiftskitBackend.ExerciseRoots.ExerciseRoot

  @doc """
  Renders a list of exercise_roots.
  """
  def index(%{exercise_roots: exercise_roots}) do
    %{data: for(exercise_root <- exercise_roots, do: data(exercise_root))}
  end

  @doc """
  Renders a single exercise_root.
  """
  def show(%{exercise_root: exercise_root}) do
    %{data: data(exercise_root)}
  end

  defp data(%ExerciseRoot{} = exercise_root) do
    %{
      id: exercise_root.id,
      name: exercise_root.name,
      _type: exercise_root._type
    }
  end
end
