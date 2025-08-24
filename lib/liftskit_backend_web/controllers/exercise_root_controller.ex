defmodule LiftskitBackendWeb.ExerciseRootController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.ExerciseRoots
  alias LiftskitBackend.ExerciseRoots.ExerciseRoot

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    exercise_roots = ExerciseRoots.list_exercise_roots(conn.assigns.current_scope)
    render(conn, :index, exercise_roots: exercise_roots)
  end

  def create(conn, exercise_root_params) do
    with {:ok, %ExerciseRoot{} = exercise_root} <- ExerciseRoots.create_exercise_root(conn.assigns.current_scope, exercise_root_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/exercise_roots/#{exercise_root}")
      |> render(:show, exercise_root: exercise_root)
    end
  end

  def show(conn, %{"id" => id}) do
    exercise_root = ExerciseRoots.get_exercise_root!(conn.assigns.current_scope, id)
    render(conn, :show, exercise_root: exercise_root)
  end

  def update(conn, %{"id" => id, "exercise_root" => exercise_root_params}) do
    exercise_root = ExerciseRoots.get_exercise_root!(conn.assigns.current_scope, id)

    with {:ok, %ExerciseRoot{} = exercise_root} <- ExerciseRoots.update_exercise_root(conn.assigns.current_scope, exercise_root, exercise_root_params) do
      render(conn, :show, exercise_root: exercise_root)
    end
  end

  def delete(conn, %{"id" => id}) do
    exercise_root = ExerciseRoots.get_exercise_root!(conn.assigns.current_scope, id)

    with {:ok, %ExerciseRoot{}} <- ExerciseRoots.delete_exercise_root(conn.assigns.current_scope, exercise_root) do
      send_resp(conn, :no_content, "")
    end
  end
end
