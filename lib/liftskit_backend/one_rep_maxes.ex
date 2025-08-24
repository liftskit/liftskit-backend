defmodule LiftskitBackend.OneRepMaxes do
  @moduledoc """
  The OneRepMaxes context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.OneRepMaxes.OneRepMax
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any one_rep_max changes.

  The broadcasted messages match the pattern:

    * {:created, %OneRepMax{}}
    * {:updated, %OneRepMax{}}
    * {:deleted, %OneRepMax{}}

  """
  def subscribe_one_rep_max(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:one_rep_max")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:one_rep_max", message)
  end

  @doc """
  Returns the list of one_rep_max.

  ## Examples

      iex> list_one_rep_max(scope)
      [%OneRepMax{}, ...]

  """
  def list_one_rep_max(%Scope{} = scope) do
    Repo.all_by(OneRepMax, user_id: scope.user.id)
  end

  @doc """
  Gets a single one_rep_max.

  Raises `Ecto.NoResultsError` if the One rep max does not exist.

  ## Examples

      iex> get_one_rep_max!(scope, 123)
      %OneRepMax{}

      iex> get_one_rep_max!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_one_rep_max!(%Scope{} = scope, id) do
    Repo.get_by!(OneRepMax, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a one_rep_max.

  ## Examples

      iex> create_one_rep_max(scope, %{field: value})
      {:ok, %OneRepMax{}}

      iex> create_one_rep_max(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_one_rep_max(%Scope{} = scope, attrs) do
    with {:ok, one_rep_max = %OneRepMax{}} <-
           %OneRepMax{}
           |> OneRepMax.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, one_rep_max})
      {:ok, one_rep_max}
    end
  end

  @doc """
  Updates a one_rep_max.

  ## Examples

      iex> update_one_rep_max(scope, one_rep_max, %{field: new_value})
      {:ok, %OneRepMax{}}

      iex> update_one_rep_max(scope, one_rep_max, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_one_rep_max(%Scope{} = scope, %OneRepMax{} = one_rep_max, attrs) do
    true = one_rep_max.user_id == scope.user.id

    with {:ok, one_rep_max = %OneRepMax{}} <-
           one_rep_max
           |> OneRepMax.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, one_rep_max})
      {:ok, one_rep_max}
    end
  end

  @doc """
  Deletes a one_rep_max.

  ## Examples

      iex> delete_one_rep_max(scope, one_rep_max)
      {:ok, %OneRepMax{}}

      iex> delete_one_rep_max(scope, one_rep_max)
      {:error, %Ecto.Changeset{}}

  """
  def delete_one_rep_max(%Scope{} = scope, %OneRepMax{} = one_rep_max) do
    true = one_rep_max.user_id == scope.user.id

    with {:ok, one_rep_max = %OneRepMax{}} <-
           Repo.delete(one_rep_max) do
      broadcast(scope, {:deleted, one_rep_max})
      {:ok, one_rep_max}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking one_rep_max changes.

  ## Examples

      iex> change_one_rep_max(scope, one_rep_max)
      %Ecto.Changeset{data: %OneRepMax{}}

  """
  def change_one_rep_max(%Scope{} = scope, %OneRepMax{} = one_rep_max, attrs \\ %{}) do
    true = one_rep_max.user_id == scope.user.id

    OneRepMax.changeset(one_rep_max, attrs, scope)
  end
end
