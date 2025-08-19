defmodule LiftskitBackend.Repo do
  use Ecto.Repo,
    otp_app: :liftskit_backend,
    adapter: Ecto.Adapters.Postgres
end
