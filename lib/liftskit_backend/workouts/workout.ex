defmodule LiftskitBackend.Workouts.Workout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts" do
    field :name, :string
    field :bestWorkoutTime, :string

    # Use camelCase field name that matches the database column
    belongs_to :program, LiftskitBackend.Programs.Program, foreign_key: :programId
    has_many :exercises, LiftskitBackend.Exercises.Exercise, foreign_key: :workoutId

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [:name, :bestWorkoutTime, :programId])
    |> validate_required([:name, :bestWorkoutTime, :programId])
    |> foreign_key_constraint(:programId)
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
