defmodule LiftskitBackendWeb.OneRepMaxJSON do
  alias LiftskitBackend.OneRepMaxes.OneRepMax

  @doc """
  Renders a list of one_rep_max.
  """
  def index(%{one_rep_max: one_rep_max}) do
    %{data: for(one_rep_max <- one_rep_max, do: data(one_rep_max))}
  end

  @doc """
  Renders a one_rep_max after creation or handles errors.
  """
  def create(%{one_rep_max: one_rep_max}) do
    %{data: data(one_rep_max)}
  end

  def create(%{json: %{error: message}}) do
    %{error: message}
  end

  @doc """
  Renders a single one_rep_max.
  """
  def show(%{one_rep_max: one_rep_max}) do
    %{data: data(one_rep_max)}
  end

  defp data(%OneRepMax{} = one_rep_max) do
    %{
      id: one_rep_max.id,
      exerciseName: one_rep_max.exerciseName,
      oneRepMax: one_rep_max.oneRepMax
    }
  end
end
