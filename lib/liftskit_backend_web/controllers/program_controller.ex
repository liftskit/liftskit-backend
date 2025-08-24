defmodule LiftskitBackendWeb.ProgramController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Programs
  alias LiftskitBackend.Programs.Program

  action_fallback LiftskitBackendWeb.FallbackController

  def index(conn, _params) do
    programs = Programs.list_programs(conn.assigns.current_scope)
    render(conn, :index, programs: programs)
  end

  def create(conn, program_params) do
    with {:ok, %Program{} = program} <- Programs.create_program(conn.assigns.current_scope, program_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/programs/#{program}")
      |> render(:show, program: program)
    end
  end

  def show(conn, %{"id" => id}) do
    program = Programs.get_program!(conn.assigns.current_scope, id)
    render(conn, :show, program: program)
  end

  def update(conn, program_params) do
    program = Programs.get_program!(conn.assigns.current_scope, program_params["id"])

    case Programs.get_program!(conn.assigns.current_scope, program_params["id"]) do
      %Program{} ->
        with {:ok, %Program{} = program} <- Programs.update_program(conn.assigns.current_scope, program, program_params) do
          render(conn, :show, program: program)
        end
      nil ->
        conn
        |> put_status(:not_found)
        |> render(json: %{error: "Program not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    program = Programs.get_program!(conn.assigns.current_scope, id)

    with {:ok, %Program{}} <- Programs.delete_program(conn.assigns.current_scope, program) do
      send_resp(conn, :no_content, "")
    end
  end
end
