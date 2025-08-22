defmodule LiftskitBackend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs, user_scope) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_change(:user_id, user_scope.user.id)
  end
end
