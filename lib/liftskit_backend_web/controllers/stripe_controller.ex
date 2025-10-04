defmodule LiftskitBackendWeb.StripeController do
  use LiftskitBackendWeb, :controller

  action_fallback LiftskitBackendWeb.FallbackController

  def membership_created(conn, params) do
    IO.inspect(params)

    user = LiftskitBackend.Users.get_user_by_email(params["email"])
    if user do
      one_month_in_seconds = 30 * 24 * 60 * 60
      expires_at = DateTime.from_unix(DateTime.utc_now().unix + one_month_in_seconds)
      LiftskitBackend.Users.update_user(user, %{membership_status: "active", membership_expires_at: expires_at})
    end

    conn
    |> put_status(:ok)
    |> json(%{message: "Membership created"})
  end


end
