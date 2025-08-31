defmodule LiftskitBackend.WorkoutsPerformed.WorkoutPerformed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts_performed" do
    field :program_name, :string
    field :workout_date, :utc_datetime
    field :workout_time, :integer
    field :workout_name, :string

    belongs_to :user, LiftskitBackend.Accounts.User, foreign_key: :user_id
    has_many :exercises_performed, LiftskitBackend.ExercisesPerformed.ExercisePerformed, foreign_key: :workout_performed_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workout_performed, attrs) do
    workout_performed
    |> cast(attrs, [:program_name, :workout_date, :workout_time, :workout_name, :user_id])
    |> validate_required([:program_name, :workout_date, :workout_time, :workout_name, :user_id])
    |> foreign_key_constraint(:user_id)
    |> cast_assoc(:exercises_performed, with: &LiftskitBackend.ExercisesPerformed.ExercisePerformed.changeset/2)
    |> validate_exercises_present()
  end

  defp validate_exercises_present(changeset) do
    exercises = get_field(changeset, :exercises_performed) || []

    if length(exercises) >= 1 do
      changeset
    else
      add_error(changeset, :exercises_performed, "must have at least one exercise")
    end
  end
end
