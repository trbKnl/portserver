defmodule Portserver.StorageBackend.LocalStorageWorker do
  use GenServer
  require Logger

  def start_link(storage_dir) do
    GenServer.start_link(__MODULE__, storage_dir)
  end

  @impl true
  def init(storage_dir) do
    Logger.info("Starting local storage worker #{inspect self()}")
    {:ok, storage_dir}
  end

  @impl true
  def handle_cast({:store, path, data}, storage_dir) do
    Path.join(storage_dir, path)
      |> create_folder()
      |> File.write!(data)

    {:noreply, storage_dir}
  end

  defp create_folder(path) do
    path 
      |> Path.dirname()
      |> File.mkdir_p!()

    path
  end
end

