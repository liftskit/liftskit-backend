defmodule LiftskitBackend.ExerciseRoots.ExerciseRoot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exercise_roots" do
    field :name, :string
    field :_type, Ecto.Enum, values: [:Strength, :Bodyweight, :Cardio]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise_root, attrs) do
    exercise_root
    |> cast(attrs, [:name, :_type])
    |> validate_required([:name, :_type])
    |> validate_inclusion(:_type, [:Strength, :Bodyweight, :Cardio])
    |> unique_constraint(:name)
  end
end
