defmodule LiftskitBackendWeb.UserSessionController do
  use LiftskitBackendWeb, :controller

  alias LiftskitBackend.Accounts
  alias LiftskitBackendWeb.UserAuth
  import LiftskitBackend.Validation

  def create(conn, %{"_action" => "confirmed"} = params) do
    create(conn, params, "User confirmed successfully.")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  # email login (magic link only)
  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email} = user_params

    if user = Accounts.get_user_by_email(email) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log-in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  # Mobile API Endpoints
  def signin(conn, params) do
    case params do
      %{"email" => email, "login_code" => login_code} when is_valid_email(email) ->
        case Accounts.get_user_by_email(email) do
          nil ->
            IO.puts("Invalid email or login code")
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid email or login code"})
          user ->
            # Verify login_code matches user's stored login_code and is not expired
            if LiftskitBackend.Accounts.User.valid_login_code?(user, login_code) do
              # Generate a new session token for the user
              token = Accounts.generate_user_session_token(user)

              # Generate a socket token for real-time messaging
              socket_token = Phoenix.Token.sign(LiftskitBackendWeb.Endpoint, "user socket", user.id)

              IO.puts("Login successful")
              conn
              |> put_status(:ok)
              |> json(%{
                message: "Login successful",
                user: %{
                  id: user.id,
                  email: user.email,
                  username: user.username,
                  dark_mode: user.dark_mode
                },
                token: token,
                socket_token: socket_token
              })
            else
              IO.puts("Invalid or expired login code")
              conn
              |> put_status(:unauthorized)
              |> json(%{error: "Invalid or expired login code"})
            end
        end

      %{"email" => email} when is_valid_email(email) ->
        IO.puts("Login code is required for mobile signin")
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Login code is required for mobile signin"})

      _ ->
        IO.puts("Email and login code are required")
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Email and login code are required"})
    end
  end

  def signup(conn, params) do
    case params do
      %{"email" => email, "username" => username}
        when is_valid_email(email) and is_valid_username(username) ->
          case Accounts.register_user(%{email: email, username: username}) do
            {:ok, user} ->
              # Generate a new session token for the user
              token = Accounts.generate_user_session_token(user)

              # Generate a socket token for real-time messaging
              socket_token = Phoenix.Token.sign(LiftskitBackendWeb.Endpoint, "user socket", user.id)

              conn
              |> put_status(:created)
              |> json(%{
                message: "Registration successful",
                user: %{
                  id: user.id,
                  email: user.email,
                  username: user.username,
                  dark_mode: user.dark_mode
                },
                token: token,
                socket_token: socket_token
              })
            {:error, changeset} ->
              IO.puts("Registration failed: #{inspect(changeset)}")
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Registration failed", details: format_changeset_errors(changeset)})
          end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Email and username are required"})
    end
  end

  # Private functions below

  # Helper function to format changeset errors for JSON response
  defp format_changeset_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _opts}} -> {Atom.to_string(field), message} end)
    |> Enum.into(%{})
  end


  def generate_login_code() do
    :crypto.strong_rand_bytes(12) |> Base.url_encode64(padding: false)
  end
end
