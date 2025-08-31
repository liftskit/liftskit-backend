defmodule LiftskitBackend.Programs do
  @moduledoc """
  The Programs context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Programs.Program
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any program changes.

  The broadcasted messages match the pattern:

    * {:created, %Program{}}
    * {:updated, %Program{}}
    * {:deleted, %Program{}}

  """
  def subscribe_programs(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:programs")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:programs", message)
  end

  @doc """
  Returns the list of programs.

  ## Examples

      iex> list_programs(scope)
      [%Program{}, ...]

  """
  def list_programs(%Scope{} = scope) do
    Repo.all_by(Program, user_id: scope.user.id)
  end

  @doc """
  Gets a single program.

  Raises `Ecto.NoResultsError` if the Program does not exist.

  ## Examples

      iex> get_program!(scope, 123)
      %Program{}

      iex> get_program!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_program!(%Scope{} = scope, id) do
    Repo.get_by!(Program, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a program.

  ## Examples

      iex> create_program(scope, %{field: value})
      {:ok, %Program{}}

      iex> create_program(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_program(%Scope{} = scope, attrs) do
    attrs = Map.put(attrs, "user_id", scope.user.id)

    with {:ok, program = %Program{}} <-
           %Program{}
           |> Program.changeset(attrs)
           |> Repo.insert() do
      broadcast(scope, {:created, program})
      {:ok, program}
    end
  end

  @doc """
  Updates a program.

  ## Examples

      iex> update_program(scope, program, %{field: new_value})
      {:ok, %Program{}}

      iex> update_program(scope, program, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_program(%Scope{} = scope, %Program{} = program, attrs) do
    true = program.user_id == scope.user.id

    with {:ok, program = %Program{}} <-
           program
           |> Program.changeset(attrs)
           |> Repo.update() do
      broadcast(scope, {:updated, program})
      {:ok, program}
    end
  end

  @doc """
  Deletes a program.

  ## Examples

      iex> delete_program(scope, program)
      {:ok, %Program{}}

      iex> delete_program(scope, program)
      {:error, %Ecto.Changeset{}}

  """
  def delete_program(%Scope{} = scope, %Program{} = program) do
    true = program.user_id == scope.user.id

    with {:ok, program = %Program{}} <-
           Repo.delete(program) do
      broadcast(scope, {:deleted, program})
      {:ok, program}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking program changes.

  ## Examples

      iex> change_program(scope, program)
      %Ecto.Changeset{data: %Program{}}

  """
  def change_program(%Scope{} = scope, %Program{} = program, attrs \\ %{}) do
    true = program.user_id == scope.user.id

    Program.changeset(program, attrs)
  end
end
