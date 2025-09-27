defmodule LiftskitBackendWeb.HealthController do
  use LiftskitBackendWeb, :controller

  def health(conn, _params) do
    # Simple health check that returns 200 OK
    json(conn, %{status: "ok", timestamp: DateTime.utc_now()})
  end
end
