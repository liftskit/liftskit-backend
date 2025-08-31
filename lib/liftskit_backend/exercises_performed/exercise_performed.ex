defmodule LiftskitBackend.ExercisesPerformed.ExercisePerformed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exercise_performed" do
    field :_type, Ecto.Enum, values: [:Strength, :Bodyweight, :Cardio]
    field :name, :string
    field :reps, :integer
    field :sets, :integer
    field :time, :integer
    field :weight, :integer

    belongs_to :workout_performed, LiftskitBackend.WorkoutsPerformed.WorkoutPerformed, foreign_key: :workout_performed_id

    # join table for superset exercises
    has_many :exercise_performed_superset, LiftskitBackend.ExercisesPerformed.ExercisePerformedSuperset, foreign_key: :exercise_performed_id
    has_many :superset_exercises, through: [:exercise_performed_superset, :superset_exercises]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise_performed, attrs) do
    exercise_performed
    |> cast(attrs, [:_type, :name, :reps, :sets, :time, :weight, :workout_performed_id])
    |> validate_required([:_type, :name, :reps, :sets, :time, :weight])
    |> foreign_key_constraint(:workout_performed_id)
  end
end
