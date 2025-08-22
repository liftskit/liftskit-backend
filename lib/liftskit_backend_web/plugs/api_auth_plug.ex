defmodule LiftskitBackendWeb.ApiAuthPlug do
  @moduledoc """
  Plug for authenticating API requests using Bearer tokens.

  This plug extracts the Authorization header, validates the token,
  and assigns the current user to the connection.

  ## Usage

  In your router:

      pipeline :api do
        plug :accepts, ["json"]
        plug LiftskitBackendWeb.ApiAuthPlug
      end

  Or in individual controllers:

      plug LiftskitBackendWeb.ApiAuthPlug when action in [:index, :create, :show, :update, :delete]
  """

  import Plug.Conn
  import Phoenix.Controller
  alias LiftskitBackend.Accounts
  alias LiftskitBackend.Accounts.Scope

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_current_user_from_token(conn) do
      {:ok, user} ->
        # Assign the user and scope to the connection
        conn
        |> assign(:current_user, user)
        |> assign(:current_scope, Scope.for_user(user))

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Authentication required", code: "UNAUTHORIZED"})
        |> halt()

      {:error, :invalid_token} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid token", code: "INVALID_TOKEN"})
        |> halt()
    end
  end

  # Private function to extract and validate token from Authorization header
  defp get_current_user_from_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> encoded_token] ->
        # URL-decode the token before validation
        case Base.url_decode64(encoded_token, padding: false) do
          {:ok, decoded_token} ->
            case Accounts.get_user_by_session_token(decoded_token) do
              {user, _token_inserted_at} -> {:ok, user}
              nil -> {:error, :invalid_token}
            end

          :error ->
            {:error, :invalid_token}
        end

      _ ->
        {:error, :unauthorized}
    end
  end
end
