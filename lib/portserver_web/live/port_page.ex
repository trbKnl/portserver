defmodule PortserverWeb.Live.PortPage do
  use Phoenix.LiveView

  alias Portserver.StorageBackend.LocalStorage

  @impl true
  def mount(
        %{"id" => id, "participant" => participant} = _params,
        _session,
        socket
      ) do
    {:ok, assign(socket, id: id, locale: "nl", participant: participant)}
  end

  @impl true
  def handle_event(
        "donate",
        %{"__type__" => "CommandSystemDonate", "key" => key, "json_string" => json_string},
        socket
      ) do
    LocalStorage.store(socket.assigns.participant, key, json_string)
    {:noreply, socket}
  end

  @impl true
  def handle_event("port_loading_done", _value, socket) do
    {
      :noreply,
      push_event(socket, "js-exec", %{
        to: "#port_loader",
        attr: "spinner-status-hide"
      })
    }
  end

  @impl true
  def handle_info({:change_locale, locale}, socket) do
    {:noreply, assign(socket, locale: locale)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <header class="flex items-center justify-between px-4 py-3 header border-b border-gray-200">
      <img src="/assets/port_wide.svg" alt="Port">
      <div>
        <.live_component
          module={PortserverWeb.Live.Components.LocaleChangeFlag}
          id="locale_change_flag"
          locale={@locale}
        />
      </div>
    </header>

    <div class="flex h-screen">
      <div class="m-auto">
        <div
          class="h-full"
          id="port"
          phx-hook="Port"
          data-locale={@locale}
          data-participant={@participant}
        />
        <.live_component module={PortserverWeb.Live.Components.Spinner} id="port_loader" />
      </div>
    </div>
    """
  end
end

#  @impl true
#  def render(assigns) do
#    ~H"""
#      <h1> YOLO </h1>
#      <input type="text" name="user[phone_number]" id="user-phone-number" phx-hook="PhoneNumber"/>
#    """
#  end


#  def store_results(
#        %{assigns: %{session: session, remote_ip: remote_ip, vm: %{storage: storage_key} = vm}} =
#          socket,
#        key,
#        json_string
#      )
#      when is_binary(json_string) do
#    state = Map.merge(session, %{"key" => key})
#    packet_size = String.length(json_string)
#
#    with :granted <- Rate.Public.request_permission(:azure_blob, remote_ip, packet_size) do
#      %{
#        storage_key: storage_key,
#        state: state,
#        vm: vm,
#        data: json_string
#      }
#      |> DataDonation.Delivery.new()
#      |> Oban.insert()
#    end
#
#    socket
#  end
