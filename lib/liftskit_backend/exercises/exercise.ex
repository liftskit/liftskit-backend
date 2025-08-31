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

    # Superset relationships
    has_many :exercise_supersets, LiftskitBackend.Exercises.ExerciseSuperset, foreign_key: :exercise_id
    has_many :superset_exercises, through: [:exercise_supersets, :superset_exercise]

    belongs_to :workout, LiftskitBackend.Workouts.Workout, foreign_key: :workoutId
    belongs_to :exercise_root, LiftskitBackend.ExerciseRoots.ExerciseRoot, foreign_key: :exerciseRoot

    timestamps(type: :utc_datetime)
  end

  @spec changeset(any(), map()) :: Ecto.Changeset.t()
  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:ormPercent, :reps, :sets, :time, :weight, :isSuperset, :exerciseRoot])
    |> validate_required([:ormPercent, :reps, :sets, :time, :weight, :isSuperset, :exerciseRoot])
    |> foreign_key_constraint(:workoutId)
    |> foreign_key_constraint(:exerciseRoot)
  end

  @doc """
  Creates a changeset for an exercise with superset exercises.
  This handles the creation of the join table records.
  """
  def changeset_with_supersets(exercise, attrs) do
    exercise
    |> changeset(attrs)
    |> handle_superset_exercises(attrs)
  end

  defp handle_superset_exercises(changeset, %{"supersetExercises" => superset_ids}) when is_list(superset_ids) do
    # This will be handled in the context when we insert/update
    changeset
  end

  defp handle_superset_exercises(changeset, _attrs), do: changeset
end
