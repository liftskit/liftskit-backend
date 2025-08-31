defmodule LiftskitBackend.ExercisesPerformed do
  @moduledoc """
  The ExercisesPerformed context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.ExercisesPerformed.ExercisePerformed
  alias LiftskitBackend.ExercisesPerformed.ExercisePerformedSuperset
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any exercise_performed changes.

  The broadcasted messages match the pattern:

    * {:created, %ExercisePerformed{}}
    * {:updated, %ExercisePerformed{}}
    * {:deleted, %ExercisePerformed{}}

  """
  def subscribe_exercise_performed(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LiftskitBackend.PubSub, "user:#{key}:exercise_performed")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LiftskitBackend.PubSub, "user:#{key}:exercise_performed", message)
  end

  @doc """
  Returns the list of exercise_performed.

  ## Examples

      iex> list_exercise_performed(scope)
      [%ExercisePerformed{}, ...]

  """
  def list_exercise_performed(%Scope{} = _scope) do
    ExercisePerformed
    |> Repo.all()
    |> Repo.preload([:superset_exercises])
  end

  @doc """
  Gets a single exercise_performed.

  Raises `Ecto.NoResultsError` if the Exercise performed does not exist.

  ## Examples

      iex> get_exercise_performed!(scope, 123)
      %ExercisePerformed{}

      iex> get_exercise_performed!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_exercise_performed!(%Scope{} = _scope, id) do
    ExercisePerformed
    |> Repo.get_by!(id: id)
    |> Repo.preload([:superset_exercises])
  end

  @doc """
  Creates a exercise_performed.

  ## Examples

      iex> create_exercise_performed(scope, %{field: value})
      {:ok, %ExercisePerformed{}}

      iex> create_exercise_performed(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exercise_performed(%Scope{} = scope, attrs) do
    with {:ok, exercise_performed = %ExercisePerformed{}} <-
           %ExercisePerformed{}
           |> ExercisePerformed.changeset(attrs)
           |> Repo.insert() do
      # Handle superset exercises if provided
      superset_exercises = attrs["superset_exercises"]

      if superset_exercises do
        create_superset_exercises(exercise_performed, superset_exercises)
      end

      broadcast(scope, {:created, exercise_performed})

      # Reload the exercise_performed with associations to ensure superset relationships are loaded
      exercise_performed_with_associations =
        ExercisePerformed
        |> Repo.get!(exercise_performed.id)
        |> Repo.preload([:superset_exercises])

      {:ok, exercise_performed_with_associations}
    end
  end

  @doc """
  Updates a exercise_performed.

  ## Examples

      iex> update_exercise_performed(scope, exercise_performed, %{field: new_value})
      {:ok, %ExercisePerformed{}}

      iex> update_exercise_performed(scope, exercise_performed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exercise_performed(
        %Scope{} = scope,
        %ExercisePerformed{} = exercise_performed,
        attrs
      ) do
    with {:ok, exercise_performed = %ExercisePerformed{}} <-
           exercise_performed
           |> ExercisePerformed.changeset(attrs)
           |> Repo.update() do
      broadcast(scope, {:updated, exercise_performed})
      {:ok, exercise_performed}
    end
  end

  @doc """
  Deletes a exercise_performed.

  ## Examples

      iex> delete_exercise_performed(scope, exercise_performed)
      {:ok, %ExercisePerformed{}}

      iex> delete_exercise_performed(scope, exercise_performed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exercise_performed(%Scope{} = scope, %ExercisePerformed{} = exercise_performed) do
    with {:ok, exercise_performed = %ExercisePerformed{}} <-
           Repo.delete(exercise_performed) do
      broadcast(scope, {:deleted, exercise_performed})
      {:ok, exercise_performed}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exercise_performed changes.

  ## Examples

      iex> change_exercise_performed(scope, exercise_performed)
      %Ecto.Changeset{data: %ExercisePerformed{}}

  """
  def change_exercise_performed(
        %Scope{} = _scope,
        %ExercisePerformed{} = exercise_performed,
        attrs \\ %{}
      ) do
    ExercisePerformed.changeset(exercise_performed, attrs)
  end

  def create_superset_exercises(exercise, superset_ids) when is_list(superset_ids) do
    superset_ids
    |> Enum.with_index()
    |> Enum.map(fn {superset_id, index} ->
      %ExercisePerformedSuperset{}
      |> ExercisePerformedSuperset.changeset(%{
        exercise_performed_id: exercise.id,
        superset_exercise_id: superset_id,
        order: index
      })
      |> Repo.insert()
    end)
  end

  @doc """
  Gets superset exercises for a given exercise_performed.

  ## Examples

      iex> get_superset_exercises!(exercise_performed_id)
      [%ExercisePerformed{}, ...]

  """
  def get_superset_exercises!(exercise_performed_id) do
    ExercisePerformed
    |> Repo.get_by!(id: exercise_performed_id)
    |> Repo.preload([:superset_exercises])
    |> Map.get(:superset_exercises)
  end
end
