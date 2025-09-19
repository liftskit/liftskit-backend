defmodule LiftskitBackendWeb.ExercisePerformedJSON do
  alias LiftskitBackend.ExercisesPerformed.ExercisePerformed

  @doc """
  Renders a list of exercise_performed.
  """
  def index(%{exercise_performed: exercise_performed}) do
    %{data: for(exercise_performed <- exercise_performed, do: data(exercise_performed))}
  end

  @doc """
  Renders a single exercise_performed.
  """
  def show(%{exercise_performed: exercise_performed}) do
    %{data: data(exercise_performed)}
  end

  defp data(%ExercisePerformed{} = exercise_performed) do
    %{
      id: exercise_performed.id,
      _type: exercise_performed._type,
      name: exercise_performed.name,
      reps: exercise_performed.reps,
      sets: exercise_performed.sets,
      time: exercise_performed.time,
      weight: exercise_performed.weight,
    }
  end
end
