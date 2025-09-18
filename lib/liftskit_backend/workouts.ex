defmodule LiftskitBackend.Workouts do
  @moduledoc """
  The Workouts context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Workouts.Workout
  alias LiftskitBackend.Accounts.Scope
  alias LiftskitBackend.ExerciseRoots
  alias LiftskitBackend.Programs

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
    # Get workouts through programs that belong to the user
    Repo.all(
      from w in Workout,
        join: p in assoc(w, :program),
        where: p.user_id == ^scope.user.id,
        preload: [program: p, exercises: [exercise_root: [], superset_exercises: [exercise_root: []]]]
    )
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
    # Get workout through program that belongs to the user
    Repo.one!(
      from w in Workout,
        join: p in assoc(w, :program),
        where: w.id == ^id and p.user_id == ^scope.user.id,
        preload: [program: p, exercises: [exercise_root: [], superset_exercises: [exercise_root: []]]]
    )
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
    # Extract exercises data before creating the workout
    exercises_data = attrs["exercises"] || []

    program_id = get_or_create_program(scope, attrs["program_name"])

    # Process exercises to handle exercise_root lookup/creation
    processed_exercises_data = Enum.map(exercises_data, fn exercise_data ->
      process_exercise_data(scope, exercise_data)
    end)

    # Remove superset_exercises from each exercise data to avoid conflicts
    cleaned_exercises_data = Enum.map(processed_exercises_data, fn exercise_data ->
      Map.delete(exercise_data, "superset_exercises")
    end)

    # Create workout with cleaned exercise data
    workout_attrs = Map.put(attrs, "exercises", cleaned_exercises_data)

    with {:ok, workout = %Workout{}} <-
           %Workout{}
           |> Map.put(:best_workout_time, 999999999)
           |> Map.put(:program_id, program_id)
           |> Workout.changeset(workout_attrs)
           |> Repo.insert() do

      # Handle superset_exercises for all exercises in the workout
      handle_superset_exercises(workout, processed_exercises_data, scope)

      # Preload exercises and program for JSON serialization
      workout = Repo.preload(workout, [:program, exercises: [exercise_root: [], superset_exercises: [exercise_root: []]]])
      broadcast(scope, {:created, workout})
      {:ok, workout}
    end
  end

  defp get_or_create_program(scope, program_name) do
    case Programs.get_program_by_name(scope, program_name) do
      nil ->
        case Programs.create_program(scope, %{name: program_name}) do
          {:ok, program} -> program.id
          {:error, _changeset} -> raise "Failed to create program: #{program_name}"
        end
      program -> program.id
    end
  end

  # Process exercise data to handle exercise_root lookup/creation
  defp process_exercise_data(scope, exercise_data) do
    case exercise_data do
      %{"exercise_root" => %{"name" => name, "_type" => type}} ->
        # Handle new format with exercise_root object
        with {:ok, exercise_root} <- ExerciseRoots.find_or_create_exercise_root(scope, name, String.to_atom(type)) do
          # Replace exercise_root object with exercise_root_id
          exercise_data
          |> Map.delete("exercise_root")
          |> Map.put("exercise_root_id", exercise_root.id)
        else
          {:error, changeset} ->
            # If exercise root creation fails, return the original data with error
            Map.put(exercise_data, :exercise_root_error, changeset)
        end
      _ ->
        # Handle existing format with exercise_root_id
        exercise_data
    end
  end

  # Handle superset_exercises for exercises in a workout
  defp handle_superset_exercises(workout, exercises_data, scope) do
    # Reload workout with exercises to ensure we have the latest data
    workout = Repo.preload(workout, :exercises)

    Enum.each(exercises_data, fn exercise_data ->
      if exercise_data["superset_exercises"] && length(exercise_data["superset_exercises"]) > 0 do
        # Find the corresponding exercise in the workout
        exercise = Enum.find(workout.exercises, fn e ->
          e.exercise_root_id == exercise_data["exercise_root_id"]
        end)

        if exercise do
          LiftskitBackend.Exercises.create_superset_exercises(exercise, exercise_data["superset_exercises"], scope)
        end
      end
    end)
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
    # Verify ownership through the program
    true = workout.program.user_id == scope.user.id

    # Process exercises data if present
    processed_attrs = if attrs["exercises"] do
      exercises_data = attrs["exercises"] || []

      # Process exercises to handle exercise_root lookup/creation
      processed_exercises_data = Enum.map(exercises_data, fn exercise_data ->
        process_exercise_data(scope, exercise_data)
      end)

      # Remove superset_exercises from each exercise data to avoid conflicts
      cleaned_exercises_data = Enum.map(processed_exercises_data, fn exercise_data ->
        Map.delete(exercise_data, "superset_exercises")
      end)

      # Replace exercises in attrs with processed data
      Map.put(attrs, "exercises", cleaned_exercises_data)
    else
      attrs
    end

    with {:ok, workout = %Workout{}} <-
           workout
           |> Workout.changeset(processed_attrs)
           |> Repo.update() do

      # Handle superset_exercises if exercises were updated
      if attrs["exercises"] do
        exercises_data = attrs["exercises"] || []
        processed_exercises_data = Enum.map(exercises_data, fn exercise_data ->
          process_exercise_data(scope, exercise_data)
        end)
        handle_superset_exercises(workout, processed_exercises_data, scope)
      end

      # Preload exercises and program for JSON serialization
      workout = Repo.preload(workout, [:program, exercises: [exercise_root: [], superset_exercises: [exercise_root: []]]])
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
    # Verify ownership through the program
    true = workout.program.user_id == scope.user.id

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
    # Verify the workout belongs to a program owned by the user
    workout = Repo.preload(workout, :program)
    true = workout.program.user_id == scope.user.id

    Workout.changeset(workout, attrs)
  end
end
