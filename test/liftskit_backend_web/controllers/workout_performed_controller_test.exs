defmodule LiftskitBackendWeb.WorkoutPerformedControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.WorkoutsPerformedFixtures
  alias LiftskitBackend.WorkoutsPerformed.WorkoutPerformed

  @create_attrs %{
    programName: "some programName",
    workoutDate: ~U[2025-08-23 18:56:00Z],
    workoutTime: 42,
    workoutName: "some workoutName"
  }
  @update_attrs %{
    programName: "some updated programName",
    workoutDate: ~U[2025-08-24 18:56:00Z],
    workoutTime: 43,
    workoutName: "some updated workoutName"
  }
  @invalid_attrs %{programName: nil, workoutDate: nil, workoutTime: nil, workoutName: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workouts_performed", %{conn: conn} do
      conn = get(conn, ~p"/api/workouts_performed")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workout_performed" do
    test "renders workout_performed when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workouts_performed", workout_performed: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workouts_performed/#{id}")

      assert %{
               "id" => ^id,
               "programName" => "some programName",
               "workoutDate" => "2025-08-23T18:56:00Z",
               "workoutName" => "some workoutName",
               "workoutTime" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workouts_performed", workout_performed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workout_performed" do
    setup [:create_workout_performed]

    test "renders workout_performed when data is valid", %{conn: conn, workout_performed: %WorkoutPerformed{id: id} = workout_performed} do
      conn = put(conn, ~p"/api/workouts_performed/#{workout_performed}", workout_performed: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workouts_performed/#{id}")

      assert %{
               "id" => ^id,
               "programName" => "some updated programName",
               "workoutDate" => "2025-08-24T18:56:00Z",
               "workoutName" => "some updated workoutName",
               "workoutTime" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workout_performed: workout_performed} do
      conn = put(conn, ~p"/api/workouts_performed/#{workout_performed}", workout_performed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workout_performed" do
    setup [:create_workout_performed]

    test "deletes chosen workout_performed", %{conn: conn, workout_performed: workout_performed} do
      conn = delete(conn, ~p"/api/workouts_performed/#{workout_performed}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workouts_performed/#{workout_performed}")
      end
    end
  end

  defp create_workout_performed(%{scope: scope}) do
    workout_performed = workout_performed_fixture(scope)

    %{workout_performed: workout_performed}
  end
end
