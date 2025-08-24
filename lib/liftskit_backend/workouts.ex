defmodule LiftskitBackend.Workouts do
  @moduledoc """
  The Workouts context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Workouts.Workout
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any workout changes.

  The broadcasted messages match the pattern:

    * {:created, %Workout{}}
    * {:updated, %Workout{}}
    * {:deleted, %Workout{}}

  """
  def subscribe_workouts(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:workouts")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:workouts", message)
  end

  @doc """
  Returns the list of workouts.

  ## Examples

      iex> list_workouts(scope)
      [%Workout{}, ...]

  """
  def list_workouts(%Scope{} = scope) do
    Repo.all_by(Workout, user_id: scope.user.id)
  end

  @doc """
  Gets a single workout.

  Raises `Ecto.NoResultsError` if the Workout does not exist.

  ## Examples

      iex> get_workout!(scope, 123)
      %Workout{}

      iex> get_workout!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_workout!(%Scope{} = scope, id) do
    Repo.get_by!(Workout, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a workout.

  ## Examples

      iex> create_workout(scope, %{field: value})
      {:ok, %Workout{}}

      iex> create_workout(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workout(%Scope{} = scope, attrs) do
    with {:ok, workout = %Workout{}} <-
           %Workout{}
           |> Workout.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, workout})
      {:ok, workout}
    end
  end

  @doc """
  Updates a workout.

  ## Examples

      iex> update_workout(scope, workout, %{field: new_value})
      {:ok, %Workout{}}

      iex> update_workout(scope, workout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workout(%Scope{} = scope, %Workout{} = workout, attrs) do
    true = workout.user_id == scope.user.id

    with {:ok, workout = %Workout{}} <-
           workout
           |> Workout.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, workout})
      {:ok, workout}
    end
  end

  @doc """
  Deletes a workout.

  ## Examples

      iex> delete_workout(scope, workout)
      {:ok, %Workout{}}

      iex> delete_workout(scope, workout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workout(%Scope{} = scope, %Workout{} = workout) do
    true = workout.user_id == scope.user.id

    with {:ok, workout = %Workout{}} <-
           Repo.delete(workout) do
      broadcast(scope, {:deleted, workout})
      {:ok, workout}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workout changes.

  ## Examples

      iex> change_workout(scope, workout)
      %Ecto.Changeset{data: %Workout{}}

  """
  def change_workout(%Scope{} = scope, %Workout{} = workout, attrs \\ %{}) do
    true = workout.user_id == scope.user.id

    Workout.changeset(workout, attrs, scope)
  end
end
