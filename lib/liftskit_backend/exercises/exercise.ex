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
    field :exerciseRoot, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:ormPercent, :reps, :sets, :time, :weight, :isSuperset, :exerciseRoot])
    |> validate_required([:ormPercent, :reps, :sets, :time, :weight, :isSuperset, :exerciseRoot])
  end
end
