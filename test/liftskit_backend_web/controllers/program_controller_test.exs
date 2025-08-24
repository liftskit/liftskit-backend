defmodule LiftskitBackendWeb.ProgramControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.ProgramsFixtures
  alias LiftskitBackend.Programs.Program

  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description"
  }
  @invalid_attrs %{name: nil, description: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all programs", %{conn: conn} do
      conn = get(conn, ~p"/api/programs")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create program" do
    test "renders program when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/programs", program: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/programs/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/programs", program: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update program" do
    setup [:create_program]

    test "renders program when data is valid", %{conn: conn, program: %Program{id: id} = program} do
      conn = put(conn, ~p"/api/programs/#{program}", program: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/programs/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, program: program} do
      conn = put(conn, ~p"/api/programs/#{program}", program: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete program" do
    setup [:create_program]

    test "deletes chosen program", %{conn: conn, program: program} do
      conn = delete(conn, ~p"/api/programs/#{program}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/programs/#{program}")
      end
    end
  end

  defp create_program(%{scope: scope}) do
    program = program_fixture(scope)

    %{program: program}
  end
end
