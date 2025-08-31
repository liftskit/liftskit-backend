defmodule LiftskitBackend.Exercises.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "exercises" do
    field :ormPercent, :decimal
    field :reps, :integer
    field :sets, :integer
    field :time, :string
    field :weight, :integer
    field :isSuperset, :boolean, default: false

    belongs_to :workout, LiftskitBackend.Workouts.Workout, foreign_key: :workoutId
    belongs_to :exercise_root, LiftskitBackend.ExerciseRoots.ExerciseRoot, foreign_key: :exerciseRoot

    # join table for superset exercises
    has_many :exercise_supersets, LiftskitBackend.Exercises.ExerciseSuperset, foreign_key: :exercise_id
    has_many :superset_exercises, through: [:exercise_supersets, :superset_exercise]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:ormPercent, :reps, :sets, :time, :weight, :isSuperset, :exerciseRoot])
    |> validate_required([:ormPercent, :reps, :sets, :time, :weight, :isSuperset, :exerciseRoot])
    |> foreign_key_constraint(:workoutId)
    |> foreign_key_constraint(:exerciseRoot)
  end
end
