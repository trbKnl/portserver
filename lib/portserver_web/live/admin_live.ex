defmodule PortserverWeb.AdminLive do
  use PortserverWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mt-4">
      <h2 class="text-xl font-bold border-gray-200 border-b-2">Export donated data</h2>
      <.button class="px-2 py-1 mt-1" phx-click="export_database">Export</.button>
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
    #{:ok, socket, layout: false}
    {:ok, socket}
  end
end
