defmodule LiftskitBackend.Exercises do
  @moduledoc """
  The Exercises context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Exercises.Exercise
  alias LiftskitBackend.Accounts.Scope

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

      broadcast(scope, {:created, exercise})

      # Reload the exercise with associations to ensure superset relationships are loaded
      exercise_with_associations =
        Exercise
        |> Repo.get!(exercise.id)

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
      exercise_with_associations =
        Exercise
        |> Repo.get!(exercise.id)

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


  # Process superset exercise data to handle exercise_root lookup/creation
  defp process_superset_exercise_data(scope, exercise_data) do
    case exercise_data do
      %{"exercise_root" => %{"name" => name, "_type" => type}} ->
        # Handle new format with exercise_root object
        with {:ok, exercise_root} <- LiftskitBackend.ExerciseRoots.find_or_create_exercise_root(scope, name, String.to_atom(type)) do
          # Replace exercise_root object with exercise_root_id
          exercise_data
          |> Map.delete("exercise_root")
          |> Map.put("exercise_root_id", exercise_root.id)
        else
          {:error, _changeset} ->
            # If exercise root creation fails, return the original data
            exercise_data
        end
      _ ->
        # Handle existing format with exercise_root_id
        exercise_data
    end
  end
end
