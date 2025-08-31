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
      superset_exercises: (exercise_performed.superset_exercises || []) |> Enum.map(&superset_exercise_data/1)
    }
  end

  defp superset_exercise_data(superset_exercise) do
    %{
      id: superset_exercise.id,
      _type: superset_exercise._type,
      name: superset_exercise.name,
      reps: superset_exercise.reps,
      sets: superset_exercise.sets,
      time: superset_exercise.time,
      weight: superset_exercise.weight
    }
  end
end
