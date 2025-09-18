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

  # magic link login
  defp create(conn, %{"user" => %{"token" => token} = user_params}, info) do
    case Accounts.login_user_by_magic_link(token) do
      {:ok, {user, tokens_to_disconnect}} ->
        UserAuth.disconnect_sessions(tokens_to_disconnect)

        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user, user_params)

      _ ->
        conn
        |> put_flash(:error, "The link is invalid or it has expired.")
        |> redirect(to: ~p"/users/log-in")
    end
  end

  # email + password login
  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log-in")
    end
  end

  def update_password(conn, %{"user" => user_params} = params) do
    user = conn.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)
    {:ok, {_user, expired_tokens}} = Accounts.update_user_password(user, user_params)

    # disconnect all existing LiveViews with old sessions
    UserAuth.disconnect_sessions(expired_tokens)

    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  # Mobile API Endpoints
  def signin(conn, params) do
    case params do
      %{"email" => email, "password" => password} when is_valid_email(email) and is_valid_password(password) ->
        case Accounts.get_user_by_email_and_password(email, password) do
          nil ->
            IO.puts("Invalid email or password")
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid email or password"})
          user ->
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
                username: user.username
              },
              token: token,
              socket_token: socket_token
            })
        end

      %{"email" => email} when is_valid_email(email) ->
        IO.puts("Password is required for mobile signin")
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Password is required for mobile signin"})

      _ ->
        IO.puts("Email and password are required")
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Email and password are required"})
    end
  end

  def signup(conn, params) do
    case params do
      %{"email" => email, "username" => username, "password" => password, "password_confirmation" => password_confirmation}
        when is_valid_email(email) and is_valid_username(username) and is_valid_password(password) and passwords_match(password, password_confirmation) ->
          case Accounts.register_user(%{email: email, username: username, password: password, password_confirmation: password_confirmation}) do
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
                  username: user.username
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

      %{"password" => password, "password_confirmation" => password_confirmation} when not passwords_match(password, password_confirmation) ->
        IO.puts("Passwords do not match")
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Passwords do not match"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Email, username, password, and password_confirmation are required"})
    end
  end

  # Private functions below

  # Helper function to format changeset errors for JSON response
  defp format_changeset_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _opts}} -> {Atom.to_string(field), message} end)
    |> Enum.into(%{})
  end
end
