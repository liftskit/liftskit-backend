defmodule LiftskitBackendWeb.OneRepMaxControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.OneRepMaxesFixtures
  alias LiftskitBackend.OneRepMaxes.OneRepMax

  @create_attrs %{
    exerciseName: "some exerciseName",
    oneRepMax: 42
  }
  @update_attrs %{
    exerciseName: "some updated exerciseName",
    oneRepMax: 43
  }
  @invalid_attrs %{exerciseName: nil, oneRepMax: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all one-rep-max", %{conn: conn} do
      conn = get(conn, ~p"/api/one-rep-max")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create one_rep_max" do
    test "renders one_rep_max when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/one-rep-max", one_rep_max: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/one-rep-max/#{id}")

      assert %{
               "id" => ^id,
               "exerciseName" => "some exerciseName",
               "oneRepMax" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/one-rep-max", one_rep_max: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update one_rep_max" do
    setup [:create_one_rep_max]

    test "renders one_rep_max when data is valid", %{conn: conn, one_rep_max: %OneRepMax{id: id} = one_rep_max} do
      conn = put(conn, ~p"/api/one-rep-max/#{one_rep_max}", one_rep_max: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/one-rep-max/#{id}")

      assert %{
               "id" => ^id,
               "exerciseName" => "some updated exerciseName",
               "oneRepMax" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, one_rep_max: one_rep_max} do
      conn = put(conn, ~p"/api/one-rep-max/#{one_rep_max}", one_rep_max: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete one_rep_max" do
    setup [:create_one_rep_max]

    test "deletes chosen one_rep_max", %{conn: conn, one_rep_max: one_rep_max} do
      conn = delete(conn, ~p"/api/one-rep-max/#{one_rep_max}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/one-rep-max/#{one_rep_max}")
      end
    end
  end

  defp create_one_rep_max(%{scope: scope}) do
    one_rep_max = one_rep_max_fixture(scope)

    %{one_rep_max: one_rep_max}
  end
end
