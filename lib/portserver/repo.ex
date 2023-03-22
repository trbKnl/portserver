defmodule Portserver.Repo do
  use Ecto.Repo,
    otp_app: :portserver,
    adapter: Ecto.Adapters.Postgres
end
