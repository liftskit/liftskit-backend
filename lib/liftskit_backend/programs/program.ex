defmodule LiftskitBackend.Programs.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :name, :string
    field :description, :string

    belongs_to :user, LiftskitBackend.Users.User
    has_many :workouts, LiftskitBackend.Workouts.Workout

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:user_id)
  end
end
