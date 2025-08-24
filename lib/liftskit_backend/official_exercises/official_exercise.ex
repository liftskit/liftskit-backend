defmodule LiftskitBackend.OfficialExercises.OfficialExercise do
  use Ecto.Schema
  import Ecto.Changeset

  schema "official_exercises" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(official_exercise, attrs) do
    official_exercise
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
