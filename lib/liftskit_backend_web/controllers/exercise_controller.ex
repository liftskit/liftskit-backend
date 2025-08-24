defmodule LiftskitBackendWeb.ExerciseController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Exercises
  alias LiftskitBackend.Exercises.Exercise

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    exercises = Exercises.list_exercises(conn.assigns.current_scope)
    render(conn, :index, exercises: exercises)
  end

  def create(conn, exercise_params) do
    with {:ok, %Exercise{} = exercise} <- Exercises.create_exercise(conn.assigns.current_scope, exercise_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/exercises/#{exercise}")
      |> render(:show, exercise: exercise)
    end
  end

  def show(conn, %{"id" => id}) do
    exercise = Exercises.get_exercise!(conn.assigns.current_scope, id)
    render(conn, :show, exercise: exercise)
  end

  def update(conn, %{"id" => id, "exercise" => exercise_params}) do
    exercise = Exercises.get_exercise!(conn.assigns.current_scope, id)

    with {:ok, %Exercise{} = exercise} <- Exercises.update_exercise(conn.assigns.current_scope, exercise, exercise_params) do
      render(conn, :show, exercise: exercise)
    end
  end

  def delete(conn, %{"id" => id}) do
    exercise = Exercises.get_exercise!(conn.assigns.current_scope, id)

    with {:ok, %Exercise{}} <- Exercises.delete_exercise(conn.assigns.current_scope, exercise) do
      send_resp(conn, :no_content, "")
    end
  end
end
