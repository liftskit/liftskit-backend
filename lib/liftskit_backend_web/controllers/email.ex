defmodule LiftskitBackendWeb.EmailController do
  use LiftskitBackendWeb, :controller
  alias LiftskitBackend.Mailer
  alias LiftskitBackend.Users
  alias LiftskitBackend.Accounts

  def send_email_recovery(conn, %{"email" => to_email}) do
    user = Users.get_user_by_email(to_email)
    if is_nil(user) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    else
      # Generate a temporary login code and email it
      case Accounts.generate_login_code_for_user(user) do
        {:ok, updated_user} ->
          to_email = updated_user.email
          from_email = "noreply@liftskit.com"
          subject = "Liftskit login code"
          body =
            "We received a request to send you a login code.\n\n" <>
            "Your login code is: #{updated_user.login_code}\n\n" <>
            "This code will expire in 15 minutes. Please use this code to sign in. If you didn't request this, contact us at contact@liftskit.com."

          send_email(conn, to_email, from_email, subject, body)
        {:error, _changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Failed to generate login code"})
      end
    end
  end

  def send_signup_email(conn, %{"email" => to_email}) do
    user = Users.get_user_by_email(to_email)
    if is_nil(user) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found"})
    end

    to_email = user.email
    from_email = "noreply@liftskit.com"
    subject = "Liftskit signup email"
    body = "Thank you for signing up to Liftskit!"

    send_email(conn, to_email, from_email, subject, body)
  end

  defp send_email(conn, to_email, from_email, subject, body) do
    email_struct = %Swoosh.Email{}
    |> Swoosh.Email.to([{"User", to_email}])
    |> Swoosh.Email.from({"Liftskit", from_email})
    |> Swoosh.Email.subject(subject)
    |> Swoosh.Email.text_body(body)
    # Debug: Log the email content
    IO.inspect(email_struct, label: "Email being sent")

    case Mailer.deliver(email_struct) do
      {:ok, result} ->
        IO.inspect(result, label: "Email delivery success")
        conn
        |> put_status(:created)
        |> json(%{message: "Email sent successfully", message_id: result})

      {:error, reason} ->
        IO.inspect(reason, label: "Email delivery failed")
        IO.inspect(email_struct, label: "Failed email details")

        # Log detailed error information
        case reason do
          %{message: message, code: code} ->
            IO.puts("SES Error - Code: #{code}, Message: #{message}")
          error ->
            IO.puts("Delivery error: #{inspect(error)}")
        end

        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to send email", details: inspect(reason)})
    end
  end
end
