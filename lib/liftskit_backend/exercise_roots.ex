defmodule LiftskitBackend.ExerciseRoots do
  @moduledoc """
  The ExerciseRoots context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.ExerciseRoots.ExerciseRoot
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any exercise_root changes.

  The broadcasted messages match the pattern:

    * {:created, %ExerciseRoot{}}
    * {:updated, %ExerciseRoot{}}
    * {:deleted, %ExerciseRoot{}}

  """
  def subscribe_exercise_roots(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:exercise_roots")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:exercise_roots", message)
  end

  @doc """
  Returns the list of exercise_roots.

  ## Examples

      iex> list_exercise_roots(scope)
      [%ExerciseRoot{}, ...]

  """
  def list_exercise_roots(%Scope{} = _scope) do
    Repo.all(ExerciseRoot)
  end

  @doc """
  Gets a single exercise_root.

  Raises `Ecto.NoResultsError` if the Exercise root does not exist.

  ## Examples

      iex> get_exercise_root!(scope, 123)
      %ExerciseRoot{}

      iex> get_exercise_root!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_exercise_root!(%Scope{} = _scope, id) do
    Repo.get!(ExerciseRoot, id)
  end

  @doc """
  Creates a exercise_root.

  ## Examples

      iex> create_exercise_root(scope, %{field: value})
      {:ok, %ExerciseRoot{}}

      iex> create_exercise_root(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exercise_root(%Scope{} = scope, attrs) do
    with {:ok, exercise_root = %ExerciseRoot{}} <-
           %ExerciseRoot{}
           |> ExerciseRoot.changeset(attrs)
           |> Repo.insert() do
      broadcast(scope, {:created, exercise_root})
      {:ok, exercise_root}
    end
  end

  @doc """
  Updates a exercise_root.

  ## Examples

      iex> update_exercise_root(scope, exercise_root, %{field: new_value})
      {:ok, %ExerciseRoot{}}

      iex> update_exercise_root(scope, exercise_root, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exercise_root(%Scope{} = scope, %ExerciseRoot{} = exercise_root, attrs) do
    with {:ok, exercise_root = %ExerciseRoot{}} <-
           exercise_root
           |> ExerciseRoot.changeset(attrs)
           |> Repo.update() do
      broadcast(scope, {:updated, exercise_root})
      {:ok, exercise_root}
    end
  end

  @doc """
  Deletes a exercise_root.

  ## Examples

      iex> delete_exercise_root(scope, exercise_root)
      {:ok, %ExerciseRoot{}}

      iex> delete_exercise_root(scope, exercise_root)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exercise_root(%Scope{} = scope, %ExerciseRoot{} = exercise_root) do
    with {:ok, exercise_root = %ExerciseRoot{}} <-
           Repo.delete(exercise_root) do
      broadcast(scope, {:deleted, exercise_root})
      {:ok, exercise_root}
    end
  end

  @doc """
  Finds an exercise root by name and type, or creates one if it doesn't exist.

  ## Examples

      iex> find_or_create_exercise_root(scope, "Push-ups", :Bodyweight)
      {:ok, %ExerciseRoot{}}

  """
  def find_or_create_exercise_root(%Scope{} = scope, name, type) do
    # First try to find an existing exercise root
    case Repo.get_by(ExerciseRoot, name: name, _type: type) do
      nil ->
        # Create a new exercise root if it doesn't exist
        create_exercise_root(scope, %{"name" => name, "_type" => type})
      exercise_root ->
        {:ok, exercise_root}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exercise_root changes.

  ## Examples

      iex> change_exercise_root(scope, exercise_root)
      %Ecto.Changeset{data: %ExerciseRoot{}}

  """
  def change_exercise_root(%Scope{} = _scope, %ExerciseRoot{} = exercise_root, attrs \\ %{}) do
    ExerciseRoot.changeset(exercise_root, attrs)
  end
end
