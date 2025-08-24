defmodule LiftskitBackendWeb.WorkoutController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Workouts
  alias LiftskitBackend.Workouts.Workout

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    workouts = Workouts.list_workouts(conn.assigns.current_scope)
    render(conn, :index, workouts: workouts)
  end

  def create(conn, %{"workout" => workout_params}) do
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

  def update(conn, %{"id" => id, "workout" => workout_params}) do
    workout = Workouts.get_workout!(conn.assigns.current_scope, id)

    with {:ok, %Workout{} = workout} <- Workouts.update_workout(conn.assigns.current_scope, workout, workout_params) do
      render(conn, :show, workout: workout)
    end
  end

  def delete(conn, %{"id" => id}) do
    workout = Workouts.get_workout!(conn.assigns.current_scope, id)

    with {:ok, %Workout{}} <- Workouts.delete_workout(conn.assigns.current_scope, workout) do
      send_resp(conn, :no_content, "")
    end
  end
end
