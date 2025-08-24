defmodule LiftskitBackendWeb.ExerciseControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.ExercisesFixtures
  alias LiftskitBackend.Exercises.Exercise

  @create_attrs %{
    time: "some time",
    sets: 42,
    ormPercent: "120.5",
    reps: 42,
    weight: 42,
    isSuperset: true
  }
  @update_attrs %{
    time: "some updated time",
    sets: 43,
    ormPercent: "456.7",
    reps: 43,
    weight: 43,
    isSuperset: false
  }
  @invalid_attrs %{time: nil, sets: nil, ormPercent: nil, reps: nil, weight: nil, isSuperset: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all exercises", %{conn: conn} do
      conn = get(conn, ~p"/api/exercises")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create exercise" do
    test "renders exercise when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/exercises", exercise: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/exercises/#{id}")

      assert %{
               "id" => ^id,
               "isSuperset" => true,
               "ormPercent" => "120.5",
               "reps" => 42,
               "sets" => 42,
               "time" => "some time",
               "weight" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/exercises", exercise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update exercise" do
    setup [:create_exercise]

    test "renders exercise when data is valid", %{conn: conn, exercise: %Exercise{id: id} = exercise} do
      conn = put(conn, ~p"/api/exercises/#{exercise}", exercise: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/exercises/#{id}")

      assert %{
               "id" => ^id,
               "isSuperset" => false,
               "ormPercent" => "456.7",
               "reps" => 43,
               "sets" => 43,
               "time" => "some updated time",
               "weight" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, exercise: exercise} do
      conn = put(conn, ~p"/api/exercises/#{exercise}", exercise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete exercise" do
    setup [:create_exercise]

    test "deletes chosen exercise", %{conn: conn, exercise: exercise} do
      conn = delete(conn, ~p"/api/exercises/#{exercise}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/exercises/#{exercise}")
      end
    end
  end

  defp create_exercise(%{scope: scope}) do
    exercise = exercise_fixture(scope)

    %{exercise: exercise}
  end
end
