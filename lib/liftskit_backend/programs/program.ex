defmodule LiftskitBackend.Programs.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :name, :string
    field :description, :string

    # Use camelCase field name that matches the database column
    belongs_to :user, LiftskitBackend.Users.User, foreign_key: :userId
    has_many :workouts, LiftskitBackend.Workouts.Workout, foreign_key: :programId

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [:name, :description, :userId])
    |> validate_required([:name, :description, :userId])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:userId)
  end
end
