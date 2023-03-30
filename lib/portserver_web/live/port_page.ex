defmodule PortserverWeb.PortPage do
  use Phoenix.LiveView

  @impl true
  def mount(
        %{"id" => id, "participant" => participant} = _params,
        _session,
        socket
      ) do
    #vm = DataDonation.Context.get_port(id)

    {:ok,
     #assign(socket, id: id, locale: "nl", participant: participant, layout: {PortserverWeb.Layouts, :app})
     assign(socket, id: id, locale: "nl", participant: participant)
    }#|> update_menus()}
  end

  #  @impl true
  #  def handle_uri(socket) do
  #    update_menus(socket)
  #  end
  #
  #  def update_menus(socket) do
  #    socket
  #    |> assign(
  #      menus: %{
  #        desktop_navbar: %{
  #          right: [Menu.Helpers.language_switch_item(socket, :desktop_navbar, true)]
  #        }
  #      }
  #    )
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

  @impl true
  def handle_event(
        "donate",
        %{"__type__" => "CommandSystemDonate", "key" => _key, "json_string" => _json_string},
        socket
      ) do
    {
      :noreply,
      socket #|> store_results(key, json_string)
    }
  end

  def handle_event("change_locale", _value, socket) do
    locale = case socket.assigns.locale do
      "en" -> "nl"
      "nl" -> "en"
      _ -> "en"
    end
    {
      :noreply, 
      assign(socket, locale: locale) #|>
      #push_navigate(to: "/port/asdasd/asdassadasd")
    }
  end

  @impl true
  def render(assigns) do
    # OPTION PHX-UPDATE IGNORE IS NEEDED THIS IS DIFFERENT FROM OTHER VERSIONS
    ~H"""
    <header class="flex items-center justify-between px-4 py-3 header border-b border-gray-200">
      <div class="text-xl font-bold">Port</div>
      <div>
        <button phx-click="change_locale" class="px-4 py-2 border-0 p-0 rounded-md">
          <!-- <img class="rounded-md border-0 p-0" src={flag(@locale)} alt="English"> -->
          <span>some text</span>
          <div class="px-4"></div>
        </button>
      </div>
    </header>
      <div
        class="h-full"
        id="port"
        phx-hook="Port" 
        data-locale={@locale}
        data-participant={@participant}
      />
    """

    #phx-update="ignore" 
  end

  #  @impl true
  #  def render(assigns) do
  #    ~H"""
  #      <h1> YOLO </h1>
  #      <input type="text" name="user[phone_number]" id="user-phone-number" phx-hook="PhoneNumber"/>
  #    """
  #  end
end


