defmodule LiftskitBackend.Validation do
  @moduledoc """
  Common validation guards and functions used across the application.

  ## Usage

      import LiftskitBackend.Validation

      def some_function(email, password) when is_valid_email(email) and is_valid_password(password) do
        # Function body
      end
  """

  @doc """
  Guard to validate that a value is a non-empty binary string.
  """
  defguard is_valid_email(email) when is_binary(email) and email != ""

  @doc """
  Guard to validate that a password is a non-empty binary string.
  """
  defguard is_valid_password(password) when is_binary(password) and password != ""

  @doc """
  Guard to validate that a username is a non-empty binary string.
  """
  defguard is_valid_username(username) when is_binary(username) and username != ""

  @doc """
  Guard to validate that password and confirmation match.
  """
  defguard passwords_match(password, confirmation) when password == confirmation

  @doc """
  Validates that all required fields are present and valid for user registration.
  """
  def validate_registration_params(%{
        "email" => email,
        "username" => username,
        "password" => password,
        "password_confirmation" => password_confirmation
      })
      when is_valid_email(email) and is_valid_username(username) and is_valid_password(password) and
             passwords_match(password, password_confirmation) do
    {:ok, %{email: email, username: username, password: password, password_confirmation: password_confirmation}}
  end

  def validate_registration_params(_params) do
    {:error, "Invalid registration parameters"}
  end

  @doc """
  Validates that all required fields are present and valid for user signin.
  """
  def validate_signin_params(%{"email" => email, "password" => password})
      when is_valid_email(email) and is_valid_password(password) do
    {:ok, %{email: email, password: password}}
  end

  def validate_signin_params(_params) do
    {:error, "Invalid signin parameters"}
  end
end
