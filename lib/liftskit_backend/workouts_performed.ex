defmodule LiftskitBackend.WorkoutsPerformed do
  @moduledoc """
  The WorkoutsPerformed context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.WorkoutsPerformed.WorkoutPerformed
  alias LiftskitBackend.Accounts.Scope
  alias LiftskitBackend.ExercisesPerformed.ExercisePerformedSuperset

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
    |> where(user_id: ^scope.user.id)
    |> preload([exercises_performed: :superset_exercises])
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
    |> where(id: ^id, user_id: ^scope.user.id)
    |> preload([exercises_performed: :superset_exercises])
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
    attrs = Map.put(attrs, "user_id", scope.user.id)

    exercises_data = attrs["exercises_performed"] || []

    with {:ok, workout_performed = %WorkoutPerformed{}} <-
           %WorkoutPerformed{}
           |> WorkoutPerformed.changeset(attrs)
           |> Repo.insert() do

      # Reload the workout with exercises to access them
      workout_performed = Repo.preload(workout_performed, :exercises_performed)

      # Process superset exercises after main workout is created
      process_superset_exercises(workout_performed, exercises_data)

      # Reload again to get the superset exercises
      workout_performed = Repo.preload(workout_performed, [exercises_performed: :superset_exercises])

      broadcast(scope, {:created, workout_performed})
      {:ok, workout_performed}
    end
  end

  defp process_superset_exercises(workout_performed, exercises_data) do
    exercises_data
    |> Enum.with_index()
    |> Enum.each(fn {exercise_data, index} ->
      if exercise_data["is_superset"] && exercise_data["superset_exercises"] do
        # Find the main exercise that was just created
        main_exercise = find_exercise_by_data(workout_performed, exercise_data, index)

        if main_exercise do
          # Create superset exercises
          superset_exercises = create_superset_exercises(workout_performed, exercise_data["superset_exercises"])

          # Create relationships
          create_superset_relationships(main_exercise, superset_exercises)
        end
      end
    end)
  end

  defp find_exercise_by_data(workout_performed, _exercise_data, index) do
    workout_performed.exercises_performed
    |> Enum.at(index)
  end

  defp create_superset_exercises(workout_performed, superset_data) do
    superset_data
    |> Enum.map(fn superset_exercise_data ->
      superset_attrs = Map.put(superset_exercise_data, "workout_performed_id", workout_performed.id)
      superset_attrs = Map.put(superset_attrs, "is_superset", false)

      %LiftskitBackend.ExercisesPerformed.ExercisePerformed{}
      |> LiftskitBackend.ExercisesPerformed.ExercisePerformed.changeset(superset_attrs)
      |> Repo.insert!()
    end)
  end

  defp create_superset_relationships(main_exercise, superset_exercises) do
    superset_exercises
    |> Enum.with_index()
    |> Enum.each(fn {superset_exercise, order} ->
      %ExercisePerformedSuperset{}
      |> ExercisePerformedSuperset.changeset(%{
        exercise_performed_id: main_exercise.id,
        superset_exercise_id: superset_exercise.id,
        order: order
      })
      |> Repo.insert!()
    end)
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
    true = workout_performed.user_id == scope.user.id

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
    true = workout_performed.user_id == scope.user.id

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
    true = workout_performed.user_id == scope.user.id

    WorkoutPerformed.changeset(workout_performed, attrs)
  end
end
