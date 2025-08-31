defmodule LiftskitBackend.Exercises do
  @moduledoc """
  The Exercises context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Exercises.Exercise
  alias LiftskitBackend.Accounts.Scope
  alias LiftskitBackend.Exercises.ExerciseSuperset

  @doc """
  Subscribes to scoped notifications about any exercise changes.

  The broadcasted messages match the pattern:

    * {:created, %Exercise{}}
    * {:updated, %Exercise{}}
    * {:deleted, %Exercise{}}

  """
  def subscribe_exercises(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:exercises")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:exercises", message)
  end

  @doc """
  Returns the list of exercises.

  ## Examples

      iex> list_exercises(scope)
      [%Exercise{}, ...]

  """
  def list_exercises(%Scope{} = _scope) do
    Exercise
      |> Repo.all()
      |> Repo.preload([:exercise_root, :superset_exercises])
  end

  @doc """
  Gets a single exercise.

  Raises `Ecto.NoResultsError` if the Exercise does not exist.

  ## Examples

      iex> get_exercise!(scope, 123)
      %Exercise{}

      iex> get_exercise!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_exercise!(%Scope{} = _scope, id) do
    Exercise
      |> Repo.get!(id)
      |> Repo.preload([:exercise_root, :superset_exercises])
  end

  @doc """
  Creates a exercise.

  ## Examples

      iex> create_exercise(scope, %{field: value})
      {:ok, %Exercise{}}

      iex> create_exercise(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exercise(%Scope{} = scope, attrs) do
      with {:ok, exercise = %Exercise{}} <-
             %Exercise{}
             |> Exercise.changeset(attrs)
             |> Repo.insert() do

        # Handle superset exercises if provided (support both camelCase and snake_case)
        superset_exercises = attrs["superset_exercises"]
        if superset_exercises do
          create_superset_exercises(exercise, superset_exercises)
        end

        broadcast(scope, {:created, exercise})

        # Reload the exercise with associations to ensure superset relationships are loaded
        exercise_with_associations = Exercise
          |> Repo.get!(exercise.id)
          |> Repo.preload([:exercise_root, :superset_exercises])

        {:ok, exercise_with_associations}
      end
  end

  @doc """
  Updates a exercise.

  ## Examples

      iex> update_exercise(scope, exercise, %{field: new_value})
      {:ok, %Exercise{}}

      iex> update_exercise(scope, exercise, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exercise(%Scope{} = scope, %Exercise{} = exercise, attrs) do
      with {:ok, exercise = %Exercise{}} <-
             exercise
             |> Exercise.changeset(attrs)
             |> Repo.update() do
        broadcast(scope, {:updated, exercise})

        # Reload the exercise with associations
        exercise_with_associations = Exercise
          |> Repo.get!(exercise.id)
          |> Repo.preload([:exercise_root, :superset_exercises])

        {:ok, exercise_with_associations}
      end
  end

  @doc """
  Deletes a exercise.

  ## Examples

      iex> delete_exercise(scope, exercise)
      {:ok, %Exercise{}}

      iex> delete_exercise(scope, exercise)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exercise(%Scope{} = scope, %Exercise{} = exercise) do
    with {:ok, exercise = %Exercise{}} <-
           Repo.delete(exercise) do
      broadcast(scope, {:deleted, exercise})
      {:ok, exercise}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exercise changes.

  ## Examples

      iex> change_exercise(scope, exercise)
      %Ecto.Changeset{data: %Exercise{}}

  """
  def change_exercise(%Scope{} = _scope, %Exercise{} = exercise, attrs \\ %{}) do
    Exercise.changeset(exercise, attrs)
  end

    def get_superset_exercises!(%Scope{} = _scope, exercise_id) do
    Exercise
      |> Repo.get!(exercise_id)
      |> Repo.preload([:exercise_supersets, :superset_exercises])
      |> Map.get(:superset_exercises)
  end

  def create_superset_exercises(exercise, superset_ids) when is_list(superset_ids) do
    superset_ids
      |> Enum.with_index()
      |> Enum.map(fn {superset_id, index} ->
        %ExerciseSuperset{}
          |> ExerciseSuperset.changeset(%{
            exercise_id: exercise.id,
            superset_exercise_id: superset_id,
            order: index
          })
          |> Repo.insert!()
      end)
  end
end
