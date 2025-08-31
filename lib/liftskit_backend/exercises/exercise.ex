defmodule LiftskitBackend.Exercises.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "exercises" do
    field :orm_percent, :decimal
    field :reps, :integer
    field :sets, :integer
    field :time, :string
    field :weight, :integer
    field :is_superset, :boolean, default: false

    belongs_to :workout, LiftskitBackend.Workouts.Workout, foreign_key: :workout_id
    belongs_to :exercise_root, LiftskitBackend.ExerciseRoots.ExerciseRoot, foreign_key: :exercise_root_id

    # join table for superset exercises
    has_many :exercise_supersets, LiftskitBackend.Exercises.ExerciseSuperset, foreign_key: :exercise_id
    has_many :superset_exercises, through: [:exercise_supersets, :superset_exercise]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:orm_percent, :reps, :sets, :time, :weight, :is_superset, :exercise_root_id])
    |> validate_required([:orm_percent, :reps, :sets, :time, :weight, :is_superset, :exercise_root_id])
    |> foreign_key_constraint(:workout_id)
    |> foreign_key_constraint(:exercise_root_id)
  end
end
