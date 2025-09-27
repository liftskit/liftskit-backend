defmodule LiftskitBackend.Validation do
  @moduledoc """
  Common validation guards and functions used across the application.

  ## Usage

      import LiftskitBackend.Validation

      def some_function(email, login_code) when is_valid_email(email) and is_binary(login_code) do
        # Function body
      end
  """

  @doc """
  Guard to validate that a value is a non-empty binary string.
  """
  defguard is_valid_email(email) when is_binary(email) and email != ""

  @doc """
  Guard to validate that a username is a non-empty binary string.
  """
  defguard is_valid_username(username) when is_binary(username) and username != ""

  @doc """
  Validates that all required fields are present and valid for user registration.
  """
  def validate_registration_params(%{
        "email" => email,
        "username" => username
      })
      when is_valid_email(email) and is_valid_username(username) do
    {:ok, %{email: email, username: username}}
  end

  def validate_registration_params(_params) do
    {:error, "Invalid registration parameters"}
  end

  @doc """
  Validates that all required fields are present and valid for user signin.
  """
  def validate_signin_params(%{"email" => email, "login_code" => login_code})
      when is_valid_email(email) and is_binary(login_code) and login_code != "" do
    {:ok, %{email: email, login_code: login_code}}
  end

  def validate_signin_params(_params) do
    {:error, "Invalid signin parameters"}
  end
end
