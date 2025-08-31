defmodule LiftskitBackend.ExercisesPerformed.ExercisePerformedSuperset do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "exercise_performed_supersets" do
    field :order, :integer

    belongs_to :exercise_performed, LiftskitBackend.ExercisesPerformed.ExercisePerformed, foreign_key: :exercise_performed_id
    belongs_to :superset_exercises, LiftskitBackend.ExercisesPerformed.ExercisePerformed, foreign_key: :superset_exercise_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise_performed_superset, attrs) do
    exercise_performed_superset
      |> cast(attrs, [:exercise_performed_id, :superset_exercise_id])
      |> foreign_key_constraint(:exercise_performed_id)
      |> foreign_key_constraint(:superset_exercise_id)
      |> validate_required([:superset_exercise_id, :exercise_performed_id])
  end
end
