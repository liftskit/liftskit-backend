defmodule LiftskitBackendWeb.ExercisePerformedControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.ExercisesPerformedFixtures
  alias LiftskitBackend.ExercisesPerformed.ExercisePerformed

  @create_attrs %{
    name: "some name",
    time: "some time",
    sets: 42,
    _type: :strength,
    reps: 42,
    weight: 42
  }
  @update_attrs %{
    name: "some updated name",
    time: "some updated time",
    sets: 43,
    _type: :bodyweight,
    reps: 43,
    weight: 43
  }
  @invalid_attrs %{name: nil, time: nil, sets: nil, _type: nil, reps: nil, weight: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all exercise_performed", %{conn: conn} do
      conn = get(conn, ~p"/api/exercise_performed")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create exercise_performed" do
    test "renders exercise_performed when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/exercise_performed", exercise_performed: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/exercise_performed/#{id}")

      assert %{
               "id" => ^id,
               "_type" => "strength",
               "name" => "some name",
               "reps" => 42,
               "sets" => 42,
               "time" => "some time",
               "weight" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/exercise_performed", exercise_performed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update exercise_performed" do
    setup [:create_exercise_performed]

    test "renders exercise_performed when data is valid", %{conn: conn, exercise_performed: %ExercisePerformed{id: id} = exercise_performed} do
      conn = put(conn, ~p"/api/exercise_performed/#{exercise_performed}", exercise_performed: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/exercise_performed/#{id}")

      assert %{
               "id" => ^id,
               "_type" => "bodyweight",
               "name" => "some updated name",
               "reps" => 43,
               "sets" => 43,
               "time" => "some updated time",
               "weight" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, exercise_performed: exercise_performed} do
      conn = put(conn, ~p"/api/exercise_performed/#{exercise_performed}", exercise_performed: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete exercise_performed" do
    setup [:create_exercise_performed]

    test "deletes chosen exercise_performed", %{conn: conn, exercise_performed: exercise_performed} do
      conn = delete(conn, ~p"/api/exercise_performed/#{exercise_performed}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/exercise_performed/#{exercise_performed}")
      end
    end
  end

  defp create_exercise_performed(%{scope: scope}) do
    exercise_performed = exercise_performed_fixture(scope)

    %{exercise_performed: exercise_performed}
  end
end
