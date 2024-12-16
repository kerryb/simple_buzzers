defmodule SimpleBuzzers.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SimpleBuzzersWeb.Telemetry,
      SimpleBuzzers.Repo,
      {DNSCluster, query: Application.get_env(:simple_buzzers, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SimpleBuzzers.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SimpleBuzzers.Finch},
      # Start a worker by calling: SimpleBuzzers.Worker.start_link(arg)
      # {SimpleBuzzers.Worker, arg},
      # Start to serve requests, typically the last entry
      SimpleBuzzersWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleBuzzers.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SimpleBuzzersWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
