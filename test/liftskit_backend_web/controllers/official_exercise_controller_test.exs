defmodule LiftskitBackendWeb.OfficialExerciseControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.OfficialExercisesFixtures
  alias LiftskitBackend.OfficialExercises.OfficialExercise

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all official_exercises", %{conn: conn} do
      conn = get(conn, ~p"/api/official_exercises")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create official_exercise" do
    test "renders official_exercise when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/official_exercises", official_exercise: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/official_exercises/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/official_exercises", official_exercise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update official_exercise" do
    setup [:create_official_exercise]

    test "renders official_exercise when data is valid", %{conn: conn, official_exercise: %OfficialExercise{id: id} = official_exercise} do
      conn = put(conn, ~p"/api/official_exercises/#{official_exercise}", official_exercise: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/official_exercises/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, official_exercise: official_exercise} do
      conn = put(conn, ~p"/api/official_exercises/#{official_exercise}", official_exercise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete official_exercise" do
    setup [:create_official_exercise]

    test "deletes chosen official_exercise", %{conn: conn, official_exercise: official_exercise} do
      conn = delete(conn, ~p"/api/official_exercises/#{official_exercise}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/official_exercises/#{official_exercise}")
      end
    end
  end

  defp create_official_exercise(%{scope: scope}) do
    official_exercise = official_exercise_fixture(scope)

    %{official_exercise: official_exercise}
  end
end
