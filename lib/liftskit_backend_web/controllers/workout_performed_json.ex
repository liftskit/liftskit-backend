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
    %{
      id: exercise_performed.id,
      _type: exercise_performed._type,
      name: exercise_performed.name,
      reps: exercise_performed.reps,
      sets: exercise_performed.sets,
      time: exercise_performed.time,
      weight: exercise_performed.weight
    }
  end
end
