defmodule LiftskitBackend.OneRepMaxes.OneRepMax do
  use Ecto.Schema
  import Ecto.Changeset

  schema "one_rep_max" do
    field :exercise_name, :string
    field :one_rep_max, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(one_rep_max, attrs, user_scope) do
    one_rep_max
    |> cast(attrs, [:exercise_name, :one_rep_max, :user_id])
    |> validate_required([:exercise_name, :one_rep_max, :user_id])
    |> unique_constraint(:exercise_name)
    |> put_change(:user_id, user_scope.user.id)
  end
end
