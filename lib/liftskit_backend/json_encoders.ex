defmodule LiftskitBackend.JsonEncoders do
  @moduledoc """
  JSON encoders for various data types that don't have built-in Jason.Encoder implementations.
  """

  # Note: Jason already provides Jason.Encoder for Decimal, so we don't need to implement it here
  # The jason library automatically handles Decimal serialization
end
