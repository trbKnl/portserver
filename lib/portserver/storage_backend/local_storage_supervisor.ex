defmodule Portserver.StorageBackend.LocalStorageSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      :poolboy.child_spec(:local_storage_worker, poolboy_config(), [storage_directory()]),
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

  defp poolboy_config() do
    [
      name: {:local, :local_storage_worker},
      worker_module: Portserver.StorageBackend.LocalStorageWorker,
      size: 5,
      max_overflow: 0
    ]
  end

  defp storage_directory() do
    Application.fetch_env!(:portserver, :local_storage_config)
    |> Keyword.get(:storage_directory)
  end
end
