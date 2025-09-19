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

    field :is_superset, :boolean, default: false
    field :superset_group, :integer
    field :superset_order, :integer

    belongs_to :workout_performed, LiftskitBackend.WorkoutsPerformed.WorkoutPerformed, foreign_key: :workout_performed_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise_performed, attrs) do
    exercise_performed
    |> cast(attrs, [:_type, :name, :reps, :sets, :time, :weight, :workout_performed_id, :is_superset, :superset_group, :superset_order])
    |> validate_required([:_type, :name, :reps, :sets, :time, :weight, :is_superset])
    |> validate_inclusion(:_type, [:Strength, :Bodyweight, :Cardio])
    |> validate_superset_group()
    |> foreign_key_constraint(:workout_performed_id)
  end

  defp validate_superset_group(changeset) do
    if get_field(changeset, :is_superset) do
      validate_required(changeset, [:superset_group, :superset_order])
    else
      changeset
    end
  end
end
