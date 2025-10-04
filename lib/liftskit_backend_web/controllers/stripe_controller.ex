defmodule LiftskitBackendWeb.StripeController do
  @moduledoc """
  Stripe webhook handler for processing payment events.

  This controller handles Stripe webhooks, specifically:
  - invoice.paid: Automatically renews user membership when monthly payments succeed
  - Other webhook types: Acknowledges receipt but doesn't process

  Usage:
    POST /api/stripe/webhook
    Headers: Content-Type: application/json
    Body: Stripe webhook JSON payload
  """
  use LiftskitBackendWeb, :controller

  action_fallback LiftskitBackendWeb.FallbackController

  def webhook(conn, %{"type" => "invoice.paid"} = params) do
    require Logger
    Logger.info("Received invoice.paid webhook")
    Logger.info("Webhook params: #{inspect(params, limit: 100)}")

    with {:ok, payment_intent} <- parse_webhook_params(params),
         {:ok, user} <- find_user_from_email(payment_intent["customer_email"]),
         {:ok, subscription_end_time} <- calculate_subscription_end_time(payment_intent),
         {:ok, _updated_user} <- renew_user_membership(user, subscription_end_time, payment_intent) do
      Logger.info("Membership successfully renewed for user #{user.id}")
      conn
      |> put_status(:ok)
      |> json(%{message: "Membership successfully renewed"})
    else
      {:error, :user_not_found} ->
        customer_email = params["data"]["object"]["customer_email"]
        Logger.warning("User not found for customer email: #{customer_email}")
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found for customer email"})

      {:error, reason} ->
        Logger.error("Failed to process webhook: #{inspect(reason)}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to process webhook: #{inspect(reason)}"})
    end
  end

  def webhook(conn, params) do
    # Handle other webhook types or unknown events
    require Logger
    Logger.info("Received webhook with generic handler")
    Logger.info("Webhook type: #{params["type"]}")
    Logger.info("Webhook params: #{inspect(params, limit: 50)}")

    conn
    |> put_status(:ok)
    |> json(%{message: "Webhook received but not processed"})
  end

  def membership_created(conn, params) do
    IO.inspect(params)

    user = LiftskitBackend.Users.get_user_by_email(params["email"])
    if user do
      one_month_in_seconds = 30 * 24 * 60 * 60
      current_unix = DateTime.utc_now() |> DateTime.to_unix()
      expires_at = DateTime.from_unix(current_unix + one_month_in_seconds)
      LiftskitBackend.Users.update_user(user, %{membership_status: "active", membership_expires_at: expires_at})
    end

    conn
    |> put_status(:ok)
    |> json(%{message: "Membership created"})
  end

  # Private helper functions

  defp parse_webhook_params(params) do
    case params["data"]["object"] do
      nil -> {:error, :invalid_webhook_format}
      payment_intent -> {:ok, payment_intent}
    end
  end

  defp find_user_from_email(email) do
    case LiftskitBackend.Users.get_user_by_email(email) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end


  defp calculate_subscription_end_time(payment_intent) do
    # Try to get period_end directly from invoice first
    case payment_intent["period_end"] do
      nil ->
        # Fallback: extract from invoice lines
        invoice_lines = payment_intent["lines"]["data"] || []
        case invoice_lines do
          [line | _] ->
            period_end = line["period"]["end"]
            if period_end do
              end_time = DateTime.from_unix(period_end)
              {:ok, end_time}
            else
              {:error, :no_period_end}
            end
          [] ->
            {:error, :no_invoice_lines}
        end
      period_end ->
        end_time = DateTime.from_unix(period_end)
        {:ok, end_time}
    end
  end

  defp renew_user_membership(user, expires_at, payment_intent) do
    subscription_id = payment_intent["subscription"]

    membership_attrs = %{
      membership_status: "active",
      membership_expires_at: expires_at,
      stripe_subscription_id: subscription_id
    }

    LiftskitBackend.Users.update_membership(user, membership_attrs)
  end
end
