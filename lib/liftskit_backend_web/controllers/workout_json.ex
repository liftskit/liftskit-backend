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
      best_workout_time: workout.best_workout_time,
      program_id: workout.program_id,
      exercises: for(exercise <- workout.exercises, do: exercise_data(exercise))
    }
  end

  defp exercise_data(exercise) do
    %{
      id: exercise.id,
      name: exercise.name,
      _type: exercise._type,
      orm_percent: Decimal.to_float(exercise.orm_percent),
      reps: exercise.reps,
      sets: exercise.sets,
      time: exercise.time,
      weight: exercise.weight,
      is_superset: exercise.is_superset,
      superset_group: exercise.superset_group,
      superset_order: exercise.superset_order,
      workout_id: exercise.workout_id,
    }
  end


end
