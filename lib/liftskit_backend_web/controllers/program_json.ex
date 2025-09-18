defmodule LiftskitBackendWeb.ProgramJSON do
  alias LiftskitBackend.Programs.Program

  @doc """
  Renders a list of programs.
  """
  def index(%{programs: programs}) do
    %{data: for(program <- programs, do: data(program))}
  end

  @doc """
  Renders a single program.
  """
  def show(%{program: program}) do
    %{data: data(program)}
  end

  defp data(%Program{} = program) do
    %{
      id: program.id,
      name: program.name
    }
  end
end
