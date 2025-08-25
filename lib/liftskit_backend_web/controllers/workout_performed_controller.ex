defmodule LiftskitBackendWeb.WorkoutPerformedController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.WorkoutsPerformed
  alias LiftskitBackend.WorkoutsPerformed.WorkoutPerformed

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    workouts_performed = WorkoutsPerformed.list_workouts_performed(conn.assigns.current_scope)
    render(conn, :index, workouts_performed: workouts_performed)
  end

  def create(conn, workout_performed_params) do
    with {:ok, %WorkoutPerformed{} = workout_performed} <- WorkoutsPerformed.create_workout_performed(conn.assigns.current_scope, workout_performed_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workouts_performed/#{workout_performed}")
      |> render(:show, workout_performed: workout_performed)
    end
  end

  def show(conn, %{"id" => id}) do
    workout_performed = WorkoutsPerformed.get_workout_performed!(conn.assigns.current_scope, id)
    render(conn, :show, workout_performed: workout_performed)
  end

  def update(conn, %{"id" => id, "workout_performed" => workout_performed_params}) do
    workout_performed = WorkoutsPerformed.get_workout_performed!(conn.assigns.current_scope, id)

    with {:ok, %WorkoutPerformed{} = workout_performed} <- WorkoutsPerformed.update_workout_performed(conn.assigns.current_scope, workout_performed, workout_performed_params) do
      render(conn, :show, workout_performed: workout_performed)
    end
  end

  def delete(conn, %{"id" => id}) do
    workout_performed = WorkoutsPerformed.get_workout_performed!(conn.assigns.current_scope, id)

    with {:ok, %WorkoutPerformed{}} <- WorkoutsPerformed.delete_workout_performed(conn.assigns.current_scope, workout_performed) do
      send_resp(conn, :no_content, "")
    end
  end
end
