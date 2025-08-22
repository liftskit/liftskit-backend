defmodule LiftskitBackend.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :created, :utc_datetime

    belongs_to :from_user, LiftskitBackend.Accounts.User
    belongs_to :to_user, LiftskitBackend.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs, user_scope) do
    message
    |> cast(attrs, [:body, :created, :to_user_id])
    |> validate_required([:body, :to_user_id])
    |> put_change(:from_user_id, user_scope.user.id)
    |> put_change(:created, attrs["created"] || DateTime.truncate(DateTime.utc_now(), :second))
  end
end
