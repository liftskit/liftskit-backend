defmodule LiftskitBackendWeb.HealthController do
  use LiftskitBackendWeb, :controller

  def health(conn, _params) do
    json(conn, %{
      status: "ok",
      timestamp: DateTime.utc_now(),
      service: "liftskit_backend"
    })
  end

  def check(conn, _params) do
    json(conn, %{
      status: "ok",
      timestamp: DateTime.utc_now(),
      service: "liftskit_backend"
    })
  end
end
