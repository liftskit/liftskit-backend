defmodule LiftskitBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :login_code, :string
    field :login_code_expires_at, :utc_datetime
    field :confirmed_at, :utc_datetime
    field :authenticated_at, :utc_datetime, virtual: true
    field :dark_mode, :boolean, default: false

    # Membership fields
    field :membership_status, :string
    field :membership_expires_at, :utc_datetime

    # Stripe fields
    field :stripe_customer_id, :string
    field :stripe_subscription_id, :string

    timestamps(type: :utc_datetime)
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_username(opts)
    |> validate_email(opts)
  end

  def login_code_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:login_code, :login_code_expires_at])
    |> validate_login_code(opts)
    |> validate_login_code_expires_at(opts)
  end

  def settings_changeset(user, attrs) do
    user
    |> cast(attrs, [:dark_mode])
  end

  def membership_changeset(user, attrs) do
    user
    |> cast(attrs, [:membership_status, :membership_expires_at, :stripe_customer_id, :stripe_subscription_id])
    |> validate_membership_status()
  end

  def stripe_changeset(user, attrs) do
    user
    |> cast(attrs, [:stripe_customer_id, :stripe_subscription_id])
  end

  defp validate_username(changeset, _opts) do
    changeset = changeset
      |> validate_required([:username])
      |> validate_length(:username, max: 20)
      |> unique_constraint(:username)
    changeset
  end

  defp validate_email(changeset, opts) do
    changeset =
      changeset
      |> validate_required([:email])
      |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
        message: "must have the @ sign and no spaces"
      )
      |> validate_length(:email, max: 160)

    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:email, LiftskitBackend.Repo)
      |> unique_constraint(:email)
      |> validate_email_changed()
    else
      changeset
    end
  end

  defp validate_email_changed(changeset) do
    if get_field(changeset, :email) && get_change(changeset, :email) == nil do
      add_error(changeset, :email, "did not change")
    else
      changeset
    end
  end

  defp validate_login_code(changeset, _opts) do
    changeset
    |> validate_required([:login_code])
    |> validate_length(:login_code, min: 6, max: 20)
  end

  defp validate_login_code_expires_at(changeset, _opts) do
    changeset
    |> validate_required([:login_code_expires_at])
    |> validate_future_date(:login_code_expires_at)
  end

  defp validate_future_date(changeset, field) do
    case get_field(changeset, field) do
      nil -> changeset
      date ->
        if DateTime.compare(date, DateTime.utc_now()) in [:lt, :eq] do
          add_error(changeset, field, "must be in the future")
        else
          changeset
        end
    end
  end

  @doc """
  Checks if the login code is valid and not expired.
  """
  def valid_login_code?(%__MODULE__{login_code: nil}, _code), do: false
  def valid_login_code?(%__MODULE__{login_code: stored_code, login_code_expires_at: expires_at}, code) do
    stored_code == code &&
    expires_at != nil &&
    DateTime.compare(expires_at, DateTime.utc_now()) == :gt
  end
  def valid_login_code?(_, _), do: false

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now(:second)
    change(user, confirmed_at: now)
  end

  defp validate_membership_status(changeset) do
    changeset
    |> validate_inclusion(:membership_status, ["active", "inactive", "expired"])
  end
end
