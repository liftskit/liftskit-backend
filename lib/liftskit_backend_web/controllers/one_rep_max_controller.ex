defmodule LiftskitBackendWeb.OneRepMaxController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.OneRepMaxes
  alias LiftskitBackend.OneRepMaxes.OneRepMax
  alias LiftskitBackend.OfficialExercises
  alias LiftskitBackend.OfficialExercises.OfficialExercise

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    one_rep_max = OneRepMaxes.list_one_rep_max(conn.assigns.current_scope)
    render(conn, :index, one_rep_max: one_rep_max)
  end

  def create(conn, %{"exerciseName" => exercise_name, "oneRepMax" => one_rep_max}) do
    case OfficialExercises.get_official_exercise_by_name!(exercise_name) do
      %OfficialExercise{} ->
        with {:ok, %OneRepMax{} = one_rep_max} <- OneRepMaxes.create_one_rep_max(conn.assigns.current_scope, %{exerciseName: exercise_name, oneRepMax: one_rep_max, user_id: conn.assigns.current_scope.user.id}) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", ~p"/api/one_rep_max/#{one_rep_max}")
          |> render(:show, one_rep_max: one_rep_max)
        else
          {:error, _} ->
            conn
            |> put_status(:not_found)
            |> render(json: %{error: "One rep max not created"})
        end
      nil ->
        conn
        |> put_status(:not_found)
        |> render(json: %{error: "Official exercise not found or not valid"})
    end
  end

  def show(conn, %{"id" => id}) do
    one_rep_max = OneRepMaxes.get_one_rep_max!(conn.assigns.current_scope, id)
    render(conn, :show, one_rep_max: one_rep_max)
  end

  def update(conn, %{"id" => id, "oneRepMax" => updated_one_rep_max}) do
    one_rep_max = OneRepMaxes.get_one_rep_max!(conn.assigns.current_scope, id)

    with {:ok, %OneRepMax{} = one_rep_max} <- OneRepMaxes.update_one_rep_max(conn.assigns.current_scope, one_rep_max, %{oneRepMax: updated_one_rep_max}) do
      render(conn, :show, one_rep_max: one_rep_max)
    end
  end

  def delete(conn, %{"id" => id}) do
    one_rep_max = OneRepMaxes.get_one_rep_max!(conn.assigns.current_scope, id)

    with {:ok, %OneRepMax{}} <- OneRepMaxes.delete_one_rep_max(conn.assigns.current_scope, one_rep_max) do
      send_resp(conn, :no_content, "")
    end
  end
end
