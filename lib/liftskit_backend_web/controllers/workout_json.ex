defmodule LiftskitBackendWeb.WorkoutJSON do
  alias LiftskitBackend.Workouts.Workout

  @doc """
  Renders a list of workouts.
  """
  def index(%{workouts: workouts}) do
    %{data: for(workout <- workouts, do: data(workout))}
  end

  @doc """
  Renders a single workout.
  """
  def show(%{workout: workout}) do
    %{data: data(workout)}
  end

  defp data(%Workout{} = workout) do
    %{
      id: workout.id,
      name: workout.name,
      bestWorkoutTime: workout.bestWorkoutTime,
      programId: workout.programId,
      exercises: for(exercise <- workout.exercises, do: exercise_data(exercise))
    }
  end

  defp exercise_data(exercise) do
    %{
      id: exercise.id,
      ormPercent: exercise.ormPercent,
      reps: exercise.reps,
      sets: exercise.sets,
      time: exercise.time,
      weight: exercise.weight,
      isSuperset: exercise.isSuperset,
      exerciseRoot: exercise_root_data(exercise.exercise_root),
      workoutId: exercise.workoutId
    }
  end

  defp exercise_root_data(exercise_root) do
    %{
      id: exercise_root.id,
      name: exercise_root.name,
      _type: exercise_root._type
    }
  end
end
