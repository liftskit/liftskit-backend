defmodule LiftskitBackend.WorkoutsPerformed.WorkoutPerformed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts_performed" do
    field :programName, :string
    field :workoutDate, :utc_datetime
    field :workoutTime, :integer
    field :workoutName, :string

    belongs_to :user, LiftskitBackend.Users.User, foreign_key: :userId
    has_many :exercisesPerformed, LiftskitBackend.ExercisesPerformed.ExercisePerformed, foreign_key: :workoutPerformedId

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workout_performed, attrs) do
    workout_performed
    |> cast(attrs, [:programName, :workoutDate, :workoutTime, :workoutName])
    |> validate_required([:programName, :workoutDate, :workoutTime, :workoutName])
    |> foreign_key_constraint(:userId)
    |> cast_assoc(:exercisesPerformed, with: &LiftskitBackend.ExercisesPerformed.ExercisePerformed.changeset/2)
    |> validate_exercises_present()
  end

  defp validate_exercises_present(changeset) do
    exercises = get_field(changeset, :exercisesPerformed) || []

    if length(exercises) >= 1 do
      changeset
    else
      add_error(changeset, :exercisesPerformed, "must have at least one exercise")
    end
  end
end
