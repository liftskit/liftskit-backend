defmodule LiftskitBackendWeb.WorkoutPerformedJSON do
  alias LiftskitBackend.WorkoutsPerformed.WorkoutPerformed

  @doc """
  Renders a list of workouts_performed.
  """
  def index(%{workouts_performed: workouts_performed}) do
    %{data: for(workout_performed <- workouts_performed, do: data(workout_performed))}
  end

  @doc """
  Renders a single workout_performed.
  """
  def show(%{workout_performed: workout_performed}) do
    %{data: data(workout_performed)}
  end

  defp data(%WorkoutPerformed{} = workout_performed) do
    %{
      id: workout_performed.id,
      program_name: workout_performed.program_name,
      workout_date: workout_performed.workout_date,
      workout_time: workout_performed.workout_time,
      workout_name: workout_performed.workout_name,
      workout_performed: for(exercise <- workout_performed.exercises_performed, do: exercise_data(exercise))
    }
  end

  defp exercise_data(exercise_performed) do
    superset_exercises = case exercise_performed.superset_exercises do
      %Ecto.Association.NotLoaded{} -> []
      superset_exercises when is_list(superset_exercises) -> superset_exercises
      _ -> []
    end

    %{
      id: exercise_performed.id,
      _type: exercise_performed._type,
      name: exercise_performed.name,
      reps: exercise_performed.reps,
      sets: exercise_performed.sets,
      time: exercise_performed.time,
      weight: exercise_performed.weight,
      is_superset: exercise_performed.is_superset,
      superset_exercises: superset_exercises |> Enum.map(&superset_exercise_data/1)
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
      weight: superset_exercise.weight,
      is_superset: superset_exercise.is_superset
    }
  end
end
