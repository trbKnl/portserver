defmodule Portserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PortserverWeb.Telemetry,
      # Start the Ecto repository
      Portserver.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Portserver.PubSub},
      # Start Finch
      {Finch, name: Portserver.Finch},
      # Start the Endpoint (http/https)
      PortserverWeb.Endpoint,
      # Start a worker by calling: Portserver.Worker.start_link(arg)
      # {Portserver.Worker, arg}
      Portserver.StorageBackend.LocalStorageSupervisor,
      Portserver.StorageBackend.Vault,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Portserver.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    # Code that is supposed to run once right after application is started
    Portserver.Accounts.initialize_admin_from_config()

    {:ok, pid}
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PortserverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
