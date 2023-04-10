defmodule PortserverWeb.AdminLive do
  use PortserverWeb, :live_view

  def render(assigns) do
    ~H"""
    <header class="flex items-center justify-between px-4 py-3 header border-b border-gray-200">
      <div class="text-xl font-bold">Admin panel</div>
    </header>
    <div class="max-w-screen-lg mx-auto w-70">
      <div class="mt-4">
        <h2 class="text-xl font-bold border-b-2">Export donated data</h2>
        <.button class="px-2 py-1 mt-1" phx-click="export_database">Export</.button>
      </div>
    </div>
    """
  end

  def handle_event("export_database", _value, socket) do
    uris =
      Portserver.StorageBackend.DatabaseStorage.export_database()
      |> Enum.map(&Portserver.StorageBackend.DatabaseStorage.create_uri/1)
    {:noreply, push_event(socket, "download", %{uris: uris})}
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
