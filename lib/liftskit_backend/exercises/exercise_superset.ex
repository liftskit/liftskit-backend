defmodule LiftskitBackend.Exercises.ExerciseSuperset do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "exercise_supersets" do
    field :order, :integer

    belongs_to :exercise, LiftskitBackend.Exercises.Exercise, foreign_key: :exercise_id
    belongs_to :superset_exercise, LiftskitBackend.Exercises.Exercise, foreign_key: :superset_exercise_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise_superset, attrs) do
    exercise_superset
      |> cast(attrs, [:exercise_id, :superset_exercise_id, :order])
      |> foreign_key_constraint(:exercise_id)
      |> foreign_key_constraint(:superset_exercise_id)
      |> validate_required([:superset_exercise_id, :exercise_id])
  end
end
