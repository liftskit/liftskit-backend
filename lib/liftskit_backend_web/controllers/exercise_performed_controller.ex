defmodule LiftskitBackendWeb.ExercisePerformedController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.ExercisesPerformed
  alias LiftskitBackend.ExercisesPerformed.ExercisePerformed

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    exercise_performed = ExercisesPerformed.list_exercise_performed(conn.assigns.current_scope)
    render(conn, :index, exercise_performed: exercise_performed)
  end

  def create(conn, exercise_performed_params) do
    with {:ok, %ExercisePerformed{} = exercise_performed} <- ExercisesPerformed.create_exercise_performed(conn.assigns.current_scope, exercise_performed_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/exercise_performed/#{exercise_performed}")
      |> render(:show, exercise_performed: exercise_performed)
    end
  end

  def show(conn, %{"id" => id}) do
    exercise_performed = ExercisesPerformed.get_exercise_performed!(conn.assigns.current_scope, id)
    render(conn, :show, exercise_performed: exercise_performed)
  end

  def update(conn, %{"id" => id, "exercise_performed" => exercise_performed_params}) do
    exercise_performed = ExercisesPerformed.get_exercise_performed!(conn.assigns.current_scope, id)

    with {:ok, %ExercisePerformed{} = exercise_performed} <- ExercisesPerformed.update_exercise_performed(conn.assigns.current_scope, exercise_performed, exercise_performed_params) do
      render(conn, :show, exercise_performed: exercise_performed)
    end
  end

  def delete(conn, %{"id" => id}) do
    exercise_performed = ExercisesPerformed.get_exercise_performed!(conn.assigns.current_scope, id)

    with {:ok, %ExercisePerformed{}} <- ExercisesPerformed.delete_exercise_performed(conn.assigns.current_scope, exercise_performed) do
      send_resp(conn, :no_content, "")
    end
  end
end
