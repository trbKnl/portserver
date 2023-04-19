defmodule Mix.Tasks.SeedDatabase do
  @moduledoc """
  This task seeds the database with:
  * An admin user 

  This task should be run after migrations.
  """

  @shortdoc "Seed the database with an admin user"

  use Mix.Task
  require Logger

  @requirements ["app.start"]

  def run(_) do
    Logger.info("Start seeding the database")

    Portserver.Accounts.initialize_admin()

    Logger.info("Seeding the database complete")
  end

end
