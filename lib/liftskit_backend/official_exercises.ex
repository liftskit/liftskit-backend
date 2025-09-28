defmodule LiftskitBackend.OfficialExercises do
  @moduledoc """
  The OfficialExercises context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.OfficialExercises.OfficialExercise
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any official_exercise changes.

  The broadcasted messages match the pattern:

    * {:created, %OfficialExercise{}}
    * {:updated, %OfficialExercise{}}
    * {:deleted, %OfficialExercise{}}

  """
  def subscribe_official_exercises(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:official_exercises")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:official_exercises", message)
  end

  @doc """
  Returns the list of official_exercises.

  ## Examples

      iex> list_official_exercises(scope)
      [%OfficialExercise{}, ...]

  """
  def list_official_exercises() do
    Repo.all(OfficialExercise)
  end

  @doc """
  Gets a single official_exercise.

  Raises `Ecto.NoResultsError` if the Official exercise does not exist.

  ## Examples

      iex> get_official_exercise!(scope, 123)
      %OfficialExercise{}

      iex> get_official_exercise!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_official_exercise!(id) do
    Repo.get_by!(OfficialExercise, id: id)
  end

  def get_official_exercise_by_name!(name) do
    Repo.get_by!(OfficialExercise, name: name)
  end

  def get_official_exercise_by_name(name) do
    Repo.get_by(OfficialExercise, name: name)
  end

  @doc """
  Creates a official_exercise.

  ## Examples

      iex> create_official_exercise(scope, %{field: value})
      {:ok, %OfficialExercise{}}

      iex> create_official_exercise(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_official_exercise(%Scope{} = scope, attrs) do
    with {:ok, official_exercise = %OfficialExercise{}} <-
           %OfficialExercise{}
           |> OfficialExercise.changeset(attrs)
           |> Repo.insert() do
      broadcast(scope, {:created, official_exercise})
      {:ok, official_exercise}
    end
  end

  @doc """
  Updates a official_exercise.

  ## Examples

      iex> update_official_exercise(scope, official_exercise, %{field: new_value})
      {:ok, %OfficialExercise{}}

      iex> update_official_exercise(scope, official_exercise, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_official_exercise(%Scope{} = scope, %OfficialExercise{} = official_exercise, attrs) do
    with {:ok, official_exercise = %OfficialExercise{}} <-
           official_exercise
           |> OfficialExercise.changeset(attrs)
           |> Repo.update() do
      broadcast(scope, {:updated, official_exercise})
      {:ok, official_exercise}
    end
  end

  @doc """
  Deletes a official_exercise.

  ## Examples

      iex> delete_official_exercise(scope, official_exercise)
      {:ok, %OfficialExercise{}}

      iex> delete_official_exercise(scope, official_exercise)
      {:error, %Ecto.Changeset{}}

  """
  def delete_official_exercise(%Scope{} = scope, %OfficialExercise{} = official_exercise) do
    with {:ok, official_exercise = %OfficialExercise{}} <-
           Repo.delete(official_exercise) do
      broadcast(scope, {:deleted, official_exercise})
      {:ok, official_exercise}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking official_exercise changes.

  ## Examples

      iex> change_official_exercise(scope, official_exercise)
      %Ecto.Changeset{data: %OfficialExercise{}}

  """
  def change_official_exercise(%Scope{} = _scope, %OfficialExercise{} = official_exercise, attrs \\ %{}) do
    OfficialExercise.changeset(official_exercise, attrs)
  end
end
