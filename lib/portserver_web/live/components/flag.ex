defmodule PortserverWeb.Live.Components.LocaleChangeFlag do
  use Phoenix.LiveComponent

  attr :locale, :string, required: true

  def render(assigns) do
    ~H"""
      <button phx-click="change_locale" phx-target={@myself} class="px-4 py-2 border-0 p-0 rounded-md">
        <img class="rounded-md border-0 p-0" 
          src={flag(@locale) |> elem(0)} 
          alt={flag(@locale) |> elem(1)} />
        <div class="px-4"></div>
      </button>
    """
  end

  defp flag(locale) do
    case locale do
      "en" -> {"/assets/gb.svg", "English"}
      "nl" -> {"/assets/nl.svg", "Nederlands"}
      _ -> flag("en")
    end
  end

  @impl true
  def handle_event("change_locale", _value, socket) do
    new_locale =
      case socket.assigns.locale do
        "en" -> "nl"
        "nl" -> "en"
        _ -> "en"
      end
    send(self(), {:change_locale, new_locale})
    {:noreply, socket}
  end
end
