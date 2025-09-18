defmodule LiftskitBackend.Workouts.Workout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts" do
    field :name, :string
    field :best_workout_time, :integer

    # Use snake_case field name that matches the database column
    belongs_to :program, LiftskitBackend.Programs.Program, foreign_key: :program_id
    has_many :exercises, LiftskitBackend.Exercises.Exercise, foreign_key: :workout_id, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [:name, :best_workout_time, :program_id])
    |> validate_required([:name, :best_workout_time, :program_id])
    |> foreign_key_constraint(:program_id)
    |> cast_assoc(:exercises, with: &LiftskitBackend.Exercises.Exercise.changeset/2)
    |> validate_exercises_present()
    |> normalize_best_workout_time()
  end

  # Custom validation to ensure at least one exercise is present
  defp validate_exercises_present(changeset) do
    exercises = get_field(changeset, :exercises) || []

    if length(exercises) >= 1 do
      changeset
    else
      add_error(changeset, :exercises, "must have at least one exercise")
    end
  end

  # Normalize the best_workout_time field to ensure it's always a valid integer
  defp normalize_best_workout_time(changeset) do
    case get_field(changeset, :best_workout_time) do
      nil -> put_change(changeset, :best_workout_time, 999999999)
      "" -> put_change(changeset, :best_workout_time, 999999999)
      time when is_binary(time) ->
        case Integer.parse(time) do
          {int_time, ""} -> put_change(changeset, :best_workout_time, int_time)
          _ -> put_change(changeset, :best_workout_time, 999999999)
        end
      time when is_integer(time) -> changeset
      _ -> put_change(changeset, :best_workout_time, 999999999)
    end
  end
end
