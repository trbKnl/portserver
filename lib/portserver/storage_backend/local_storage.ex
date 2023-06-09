defmodule Portserver.StorageBackend.LocalStorage do
  require Logger

  @timeout 20_000

  @behaviour Portserver.StorageBackend.Behaviour
  def store(participant_id, key, data) do
    filename = Path.join(participant_id, key)
    storage_worker(filename, data)
  end

  defp storage_worker(filename, data) do
    Task.start(fn ->
      :poolboy.transaction(
        :local_storage_worker,
        fn pid ->
          GenServer.cast(pid, {:store, filename, data})
        end,
        @timeout
      )
    end)
  end
end
