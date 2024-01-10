defmodule Gitx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GitxWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:gitx, :dns_cluster_query) || :ignore},
      Gitx.Repo,
      {Phoenix.PubSub, name: Gitx.PubSub},
      {Oban, Application.fetch_env!(:gitx, Oban)},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gitx.Finch},
      # Start a worker by calling: Gitx.Worker.start_link(arg)
      # {Gitx.Worker, arg},
      # Start to serve requests, typically the last entry
      GitxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gitx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GitxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
