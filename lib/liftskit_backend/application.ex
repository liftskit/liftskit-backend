defmodule LiftskitBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiftskitBackendWeb.Telemetry,
      LiftskitBackend.Repo,
      {DNSCluster, query: Application.get_env(:liftskit_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiftskitBackend.PubSub},
      # Start a worker by calling: LiftskitBackend.Worker.start_link(arg)
      # {LiftskitBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      LiftskitBackendWeb.Endpoint,
      LiftskitBackendWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiftskitBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiftskitBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defimpl Jason.Encoder, for: Decimal do
    def encode(decimal, opts) do
      Jason.Encoder.encode(Decimal.to_string(decimal), opts)
    end
  end
end
