defmodule LiftskitBackendWeb.OfficialExerciseController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.OfficialExercises
  alias LiftskitBackend.OfficialExercises.OfficialExercise

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    official_exercises = OfficialExercises.list_official_exercises()
    render(conn, :index, official_exercises: official_exercises)
  end

  def create(conn, official_exercise_params) do
    with {:ok, %OfficialExercise{} = official_exercise} <- OfficialExercises.create_official_exercise(conn.assigns.current_scope, official_exercise_params) do
      conn
      |> put_status(:created)
      |> render(:show, official_exercise: official_exercise)
    end
  end

  def create_many(conn, official_exercise_params) do
    exercises = official_exercise_params["exercises"]
    official_exercises =
      Enum.reduce(exercises, [], fn official_exercise_param, acc ->
        with {:ok, %OfficialExercise{} = official_exercise} <- OfficialExercises.create_official_exercise(conn.assigns.current_scope, official_exercise_param) do
          [official_exercise | acc]
        else
          _ -> acc
        end
      end)

    conn
    |> put_status(:created)
    |> render(:index, official_exercises: official_exercises)
  end

  def show(conn, %{"id" => id}) do
    official_exercise = OfficialExercises.get_official_exercise!(id)
    render(conn, :show, official_exercise: official_exercise)
  end

  def update(conn, %{"id" => id, "official_exercise" => official_exercise_params}) do
    official_exercise = OfficialExercises.get_official_exercise_by_name!(id)

    with {:ok, %OfficialExercise{} = official_exercise} <- OfficialExercises.update_official_exercise(conn.assigns.current_scope, official_exercise, official_exercise_params) do
      render(conn, :show, official_exercise: official_exercise)
    end
  end

  def delete(conn, %{"id" => id}) do
    official_exercise = OfficialExercises.get_official_exercise!(id)

    with {:ok, %OfficialExercise{}} <- OfficialExercises.delete_official_exercise(conn.assigns.current_scope, official_exercise) do
      send_resp(conn, :no_content, "")
    end
  end
end
