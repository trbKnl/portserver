defmodule PortserverWeb.DownloadController do
  use PortserverWeb, :controller

  def download(conn, _params) do
    conn
      |> send_file(200, Path.join(".", current_path(conn)))
  end
end
