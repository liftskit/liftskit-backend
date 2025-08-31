defmodule LiftskitBackend.Workouts.Workout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts" do
    field :name, :string
    field :best_workout_time, :string

    # Use snake_case field name that matches the database column
    belongs_to :program, LiftskitBackend.Programs.Program, foreign_key: :program_id
    has_many :exercises, LiftskitBackend.Exercises.Exercise, foreign_key: :workout_id

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
end
