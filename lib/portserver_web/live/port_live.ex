defmodule PortserverWeb.PortLive do
  use PortserverWeb, :live_view

  alias Portserver.StorageBackend.LocalStorage

  def mount(
        %{"id" => id, "participant" => participant} = _params,
        _session,
        socket
      ) do
    {:ok, assign(socket, id: id, locale: "nl", participant: participant)}
  end

  def handle_info({:change_locale, locale}, socket) do
    {:noreply, assign(socket, locale: locale)}
  end

  def handle_event(
        "donate",
        %{
          "__type__" => "CommandSystemDonate",
          "key" => key,
          "json_string" => json_string
        },
        socket
      ) do
    LocalStorage.store(socket.assigns.participant, key, json_string)
    {:noreply, socket}
  end

  # port_loading_done is emitted by loadingDone() in port.js
  def handle_event("port_loading_done", _value, socket) do
    {
      :noreply,
      push_event(socket, "js-exec", %{
        to: "#port_loader",
        attr: "spinner-status-hide"
      })
    }
  end

  def handle_event("change_locale", _value, socket) do
    new_locale =
      case socket.assigns.locale do
        "en" -> "nl"
        "nl" -> "en"
        _ -> "en"
      end

    {:noreply, assign(socket, locale: new_locale)}
  end

  attr :locale, :string, required: true
  attr :participant, :string, required: true, doc: "a unique participant id"

  def render(assigns) do
    ~H"""
    <header class="flex items-center justify-between px-4 py-3 header border-b border-gray-200">
      <img src="/assets/port_wide.svg" alt="Port" />
      <div>
        <PortserverWeb.Components.LocaleChangeFlag.change_locale locale={@locale} />
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
        <PortserverWeb.Components.Spinner.spinner id="port_loader" />
      </div>
    </div>
    """
  end
end

#        <.live_component
#          module={PortserverWeb.Live.Components.LocaleChangeFlag}
#          id="locale_change_flag"
#          locale={@locale}
#        />
