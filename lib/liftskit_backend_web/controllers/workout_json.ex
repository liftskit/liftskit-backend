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
      orm_percent: Decimal.to_float(exercise.orm_percent),
      reps: exercise.reps,
      sets: exercise.sets,
      time: exercise.time,
      weight: exercise.weight,
      is_superset: exercise.is_superset,
      exercise_root: exercise_root_data(exercise.exercise_root),
      workout_id: exercise.workout_id,
      superset_exercises: for(superset_exercise <- exercise.superset_exercises || [], do: superset_exercise_data(superset_exercise))
    }
  end

  defp exercise_root_data(exercise_root) do
    %{
      id: exercise_root.id,
      name: exercise_root.name,
      _type: exercise_root._type
    }
  end

  defp superset_exercise_data(superset_exercise) do
    %{
      id: superset_exercise.id,
      orm_percent: Decimal.to_float(superset_exercise.orm_percent),
      reps: superset_exercise.reps,
      sets: superset_exercise.sets,
      time: superset_exercise.time,
      weight: superset_exercise.weight,
      is_superset: superset_exercise.is_superset,
      exercise_root: exercise_root_data(superset_exercise.exercise_root)
    }
  end
end
