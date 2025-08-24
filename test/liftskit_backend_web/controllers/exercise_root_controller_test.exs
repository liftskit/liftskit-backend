defmodule LiftskitBackendWeb.ExerciseRootControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.ExerciseRootsFixtures
  alias LiftskitBackend.ExerciseRoots.ExerciseRoot

  @create_attrs %{
    name: "some name",
    _type: :required
  }
  @update_attrs %{
    name: "some updated name",
    _type: :required
  }
  @invalid_attrs %{name: nil, _type: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all exercise_roots", %{conn: conn} do
      conn = get(conn, ~p"/api/exercise_roots")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create exercise_root" do
    test "renders exercise_root when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/exercise_roots", exercise_root: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/exercise_roots/#{id}")

      assert %{
               "id" => ^id,
               "_type" => "required",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/exercise_roots", exercise_root: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update exercise_root" do
    setup [:create_exercise_root]

    test "renders exercise_root when data is valid", %{conn: conn, exercise_root: %ExerciseRoot{id: id} = exercise_root} do
      conn = put(conn, ~p"/api/exercise_roots/#{exercise_root}", exercise_root: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/exercise_roots/#{id}")

      assert %{
               "id" => ^id,
               "_type" => "required",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, exercise_root: exercise_root} do
      conn = put(conn, ~p"/api/exercise_roots/#{exercise_root}", exercise_root: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete exercise_root" do
    setup [:create_exercise_root]

    test "deletes chosen exercise_root", %{conn: conn, exercise_root: exercise_root} do
      conn = delete(conn, ~p"/api/exercise_roots/#{exercise_root}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/exercise_roots/#{exercise_root}")
      end
    end
  end

  defp create_exercise_root(%{scope: scope}) do
    exercise_root = exercise_root_fixture(scope)

    %{exercise_root: exercise_root}
  end
end
