defmodule LiftskitBackend.Workouts.Workout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workouts" do
    field :name, :string
    field :bestWorkoutTime, :string

    belongs_to :program, LiftskitBackend.Programs.Program

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [:name, :bestWorkoutTime])
    |> validate_required([:name, :bestWorkoutTime])
    |> foreign_key_constraint(:program_id)
  end
end
