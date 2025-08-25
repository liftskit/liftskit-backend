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
      programName: workout_performed.programName,
      workoutDate: workout_performed.workoutDate,
      workoutTime: workout_performed.workoutTime,
      workoutName: workout_performed.workoutName
    }
  end
end
