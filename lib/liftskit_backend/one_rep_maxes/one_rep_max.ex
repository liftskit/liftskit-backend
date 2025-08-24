defmodule LiftskitBackend.OneRepMaxes.OneRepMax do
  use Ecto.Schema
  import Ecto.Changeset

  schema "one_rep_max" do
    field :exerciseName, :string
    field :oneRepMax, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(one_rep_max, attrs, user_scope) do
    one_rep_max
    |> cast(attrs, [:exerciseName, :oneRepMax, :user_id])
    |> validate_required([:exerciseName, :oneRepMax, :user_id])
    |> unique_constraint(:exerciseName)
    |> put_change(:user_id, user_scope.user.id)
  end
end
