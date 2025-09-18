defmodule LiftskitBackend.Programs.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :name, :string

    # Use snake_case field name that matches the database column
    belongs_to :user, LiftskitBackend.Accounts.User, foreign_key: :user_id
    has_many :workouts, LiftskitBackend.Workouts.Workout, foreign_key: :program_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:user_id)
  end
end
