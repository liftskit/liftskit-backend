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
      bestWorkoutTime: workout.bestWorkoutTime
    }
  end
end
