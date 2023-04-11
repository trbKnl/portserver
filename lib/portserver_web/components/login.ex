defmodule PortserverWeb.Components.Login do
  use PortserverWeb, :verified_routes
  use Phoenix.Component

  attr :current_admin, :map, required: true

  def login(assigns) do
    ~H"""
    <ul class="relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
      <%= if @current_admin do %>
        <li class="text-[0.8125rem] leading-6 text-zinc-900">
          <%= @current_admin.email %>
        </li>
        <li>
          <.link
            href={~p"/admins/log_out"}
            method="delete"
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Log out
          </.link>
        </li>
      <% else %>
        <li>
          <.link
            href={~p"/admins/register"}
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Register
          </.link>
        </li>
        <li>
          <.link
            href={~p"/admins/log_in"}
            class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
          >
            Log in
          </.link>
        </li>
      <% end %>
    </ul>
    """
  end
end


