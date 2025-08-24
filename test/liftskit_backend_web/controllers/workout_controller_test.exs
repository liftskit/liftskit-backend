defmodule LiftskitBackendWeb.WorkoutControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.WorkoutsFixtures
  alias LiftskitBackend.Workouts.Workout

  @create_attrs %{
    name: "some name",
    bestWorkoutTime: "some bestWorkoutTime"
  }
  @update_attrs %{
    name: "some updated name",
    bestWorkoutTime: "some updated bestWorkoutTime"
  }
  @invalid_attrs %{name: nil, bestWorkoutTime: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workouts", %{conn: conn} do
      conn = get(conn, ~p"/api/workouts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workout" do
    test "renders workout when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workouts", workout: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workouts/#{id}")

      assert %{
               "id" => ^id,
               "bestWorkoutTime" => "some bestWorkoutTime",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workouts", workout: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workout" do
    setup [:create_workout]

    test "renders workout when data is valid", %{conn: conn, workout: %Workout{id: id} = workout} do
      conn = put(conn, ~p"/api/workouts/#{workout}", workout: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workouts/#{id}")

      assert %{
               "id" => ^id,
               "bestWorkoutTime" => "some updated bestWorkoutTime",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workout: workout} do
      conn = put(conn, ~p"/api/workouts/#{workout}", workout: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workout" do
    setup [:create_workout]

    test "deletes chosen workout", %{conn: conn, workout: workout} do
      conn = delete(conn, ~p"/api/workouts/#{workout}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workouts/#{workout}")
      end
    end
  end

  defp create_workout(%{scope: scope}) do
    workout = workout_fixture(scope)

    %{workout: workout}
  end
end
