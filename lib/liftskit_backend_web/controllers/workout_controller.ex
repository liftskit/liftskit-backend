defmodule LiftskitBackendWeb.WorkoutController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Workouts
  alias LiftskitBackend.Workouts.Workout
  alias LiftskitBackend.Programs

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    workouts = Workouts.list_workouts(conn.assigns.current_scope)
    render(conn, :index, workouts: workouts)
  end

  def create(conn, workout_params) do
    with {:ok, %Workout{} = workout} <- Workouts.create_workout(conn.assigns.current_scope, workout_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workouts/#{workout}")
      |> render(:show, workout: workout)
    end
  end

  def show(conn, %{"id" => id}) do
    workout = Workouts.get_workout!(conn.assigns.current_scope, id)
    render(conn, :show, workout: workout)
  end

  def update(conn, %{"id" => id} = params) do
    workout = Workouts.get_workout!(conn.assigns.current_scope, id)
    workout_params = Map.delete(params, "id")

    with {:ok, %Workout{} = workout} <- Workouts.update_workout(conn.assigns.current_scope, workout, workout_params) do
      render(conn, :show, workout: workout)
    end
  end

  def delete(conn, %{"id" => id}) do
    workout = Workouts.get_workout!(conn.assigns.current_scope, id)
    program_id = workout.program_id

    # Check if this is the last workout in the program before deleting
    is_last_workout = Programs.has_only_one_workout?(conn.assigns.current_scope, program_id)

    with {:ok, %Workout{}} <- Workouts.delete_workout(conn.assigns.current_scope, workout) do
      # If this was the last workout, delete the program
      if is_last_workout do
        program = Programs.get_program!(conn.assigns.current_scope, program_id)
        Programs.delete_program(conn.assigns.current_scope, program)
      end

      send_resp(conn, :no_content, "")
    end
  end
end
