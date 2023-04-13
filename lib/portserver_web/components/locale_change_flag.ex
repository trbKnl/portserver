defmodule PortserverWeb.Components.LocaleChangeFlag do
  use PortserverWeb, :html

  attr :locale, :string, required: true

  def change_locale(assigns) do
    ~H"""
      <button phx-click="change_locale" class="px-4 py-2 border-0 p-0 rounded-md">
        <img class="rounded-md border-0 p-0" 
          src={flag(@locale) |> elem(0)} 
          alt={flag(@locale) |> elem(1)} />
        <div class="px-4"></div>
      </button>
    """
  end

  defp flag(locale) do
    case locale do
      "en" -> {~p"/icons/gb.svg", "English"}
      "nl" -> {~p"/icons/nl.svg", "Nederlands"}
      _ -> flag("en")
    end
  end

end
