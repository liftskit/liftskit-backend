defmodule LiftskitBackend.WorkoutsPerformed do
  @moduledoc """
  The WorkoutsPerformed context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.WorkoutsPerformed.WorkoutPerformed
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any workout_performed changes.

  The broadcasted messages match the pattern:

    * {:created, %WorkoutPerformed{}}
    * {:updated, %WorkoutPerformed{}}
    * {:deleted, %WorkoutPerformed{}}

  """
  def subscribe_workouts_performed(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:workouts_performed")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:workouts_performed", message)
  end

  @doc """
  Returns the list of workouts_performed.

  ## Examples

      iex> list_workouts_performed(scope)
      [%WorkoutPerformed{}, ...]

  """
  def list_workouts_performed(%Scope{} = scope) do
    WorkoutPerformed
    |> where(userId: ^scope.user.id)
    |> preload(:exercisesPerformed)
    |> Repo.all()
  end

  @doc """
  Gets a single workout_performed.

  Raises `Ecto.NoResultsError` if the Workout performed does not exist.

  ## Examples

      iex> get_workout_performed!(scope, 123)
      %WorkoutPerformed{}

      iex> get_workout_performed!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_workout_performed!(%Scope{} = scope, id) do
    WorkoutPerformed
    |> where(id: ^id, userId: ^scope.user.id)
    |> preload(:exercisesPerformed)
    |> Repo.one!()
  end

  @doc """
  Creates a workout_performed.

  ## Examples

      iex> create_workout_performed(scope, %{field: value})
      {:ok, %WorkoutPerformed{}}

      iex> create_workout_performed(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workout_performed(%Scope{} = scope, attrs) do
    attrs = Map.put(attrs, "userId", scope.user.id)

    with {:ok, workout_performed = %WorkoutPerformed{}} <-
           %WorkoutPerformed{}
           |> WorkoutPerformed.changeset(attrs)
           |> Repo.insert() do
      broadcast(scope, {:created, workout_performed})
      {:ok, workout_performed}
    end
  end

  @doc """
  Updates a workout_performed.

  ## Examples

      iex> update_workout_performed(scope, workout_performed, %{field: new_value})
      {:ok, %WorkoutPerformed{}}

      iex> update_workout_performed(scope, workout_performed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workout_performed(%Scope{} = scope, %WorkoutPerformed{} = workout_performed, attrs) do
    true = workout_performed.userId == scope.user.id

    with {:ok, workout_performed = %WorkoutPerformed{}} <-
           workout_performed
           |> WorkoutPerformed.changeset(attrs)
           |> Repo.update() do
      broadcast(scope, {:updated, workout_performed})
      {:ok, workout_performed}
    end
  end

  @doc """
  Deletes a workout_performed.

  ## Examples

      iex> delete_workout_performed(scope, workout_performed)
      {:ok, %WorkoutPerformed{}}

      iex> delete_workout_performed(scope, workout_performed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workout_performed(%Scope{} = scope, %WorkoutPerformed{} = workout_performed) do
    true = workout_performed.userId == scope.user.id

    with {:ok, workout_performed = %WorkoutPerformed{}} <-
           Repo.delete(workout_performed) do
      broadcast(scope, {:deleted, workout_performed})
      {:ok, workout_performed}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workout_performed changes.

  ## Examples

      iex> change_workout_performed(scope, workout_performed)
      %Ecto.Changeset{data: %WorkoutPerformed{}}

  """
  def change_workout_performed(%Scope{} = scope, %WorkoutPerformed{} = workout_performed, attrs \\ %{}) do
    true = workout_performed.userId == scope.user.id

    WorkoutPerformed.changeset(workout_performed, attrs)
  end
end
