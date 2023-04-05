defmodule PortserverWeb.Live.Components.Spinner do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  attr :id, :string, required: true

  def render(assigns) do
    ~H"""
    <div
      class="w-1/2 h-1/2 absolute top-1/4 left-1/4"
      id={@id}
      spinner-status-show={show_spinner(@id)}
      spinner-status-hide={hide_spinner(@id)}
    >
      <div class="flex justify-center items-center h-full">
        <div class="flex items-center justify-center">
          <div
            class="inline-block h-16 w-16 md:h-48 md:w-48 animate-spin rounded-full border-4 md:border-8 border-solid border-current border-r-transparent align-[-0.125em] motion-reduce:animate-[spin_1.5s_linear_infinite]"
            role="status"
          >
            <span class="!absolute !-m-px !h-px !w-px !overflow-hidden !whitespace-nowrap !border-0 !p-0 ![clip:rect(0,0,0,0)]">
              Loading...
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def show_spinner(js \\ %JS{}, id) do
    JS.show(js,
      to: "##{id}",
      transition: {"ease-out duration-100", "opacity-0", "opacity-100"}
    )
  end

  def hide_spinner(js \\ %JS{}, id) do
    JS.hide(js,
      to: "##{id}",
      transition: {"ease-out duration-100", "opacity-100", "opacity-0"}
    )
  end
end
