defmodule LiftskitBackend.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias LiftskitBackend.Repo

  alias LiftskitBackend.Accounts.User
  alias LiftskitBackend.Accounts.Scope

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a user by email.
  """
  def get_user_by_email(email), do:
    Repo.get_by(User, email: email)

  @doc """
  Gets a user by Stripe customer ID.
  """
  def get_user_by_stripe_customer_id(customer_id) do
    Repo.get_by(User, stripe_customer_id: customer_id)
  end

  @doc """
  Searches for users by username with fuzzy matching.

  ## Examples

      iex> search_users_by_username(scope, "john")
      [%User{}, ...]

  """
  def search_users_by_username(%Scope{} = _scope, username_query) do
    query = from u in User,
      where: ilike(u.username, ^"%#{username_query}%")
      # where: u.user_id == ^scope.user.id
    Repo.all(query)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    # Check if we're updating settings (like dark_mode) or profile info
    if Map.has_key?(attrs, :dark_mode) or Map.has_key?(attrs, "dark_mode") do
      user
      |> User.settings_changeset(attrs)
      |> Repo.update()
    else
      user
      |> User.registration_changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Updates a user's membership.

  ## Examples

      iex> update_membership(user, %{membership_status: "active", membership_expires_at: datetime})
      {:ok, %User{}}

      iex> update_membership(user, %{membership_status: "invalid"})
      {:error, %Ecto.Changeset{}}

  """
  def update_membership(%User{} = user, attrs) do
    user
    |> User.membership_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user's Stripe information.

  ## Examples

      iex> update_stripe_info(user, %{stripe_customer_id: "cus_123"})
      {:ok, %User{}}

      iex> update_stripe_info(user, %{stripe_subscription_id: "sub_456"})
      {:ok, %User{}}

  """
  def update_stripe_info(%User{} = user, attrs) do
    user
    |> User.stripe_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates the current user's settings (like dark_mode).

  ## Examples

      iex> update_current_user(user, %{dark_mode: true})
      {:ok, %User{}}

      iex> update_current_user(user, %{dark_mode: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_current_user(%User{} = user, attrs) do
    user
    |> User.settings_changeset(attrs)
    |> Repo.update()
  end



  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end
end
