defmodule LiftskitBackendWeb.OfficialExerciseJSON do
  alias LiftskitBackend.OfficialExercises.OfficialExercise

  @doc """
  Renders a list of official_exercises.
  """
  def index(%{official_exercises: official_exercises}) do
    %{data: for(official_exercise <- official_exercises, do: data(official_exercise))}
  end

  @doc """
  Renders a single official_exercise.
  """
  def show(%{official_exercise: official_exercise}) do
    %{data: data(official_exercise)}
  end

  defp data(%OfficialExercise{} = official_exercise) do
    %{
      id: official_exercise.id,
      name: official_exercise.name
    }
  end
end
