defmodule Mix.Tasks.BuildFrontend do
  @moduledoc "Builds frontend"
  @shortdoc "Build frontend"
  use Mix.Task
  require Logger

  @assets "./assets"

  def run(_) do
    Logger.info("Installing NPM packages")
    System.cmd("npm", ["install", "--quiet"], cd: @assets)

    Logger.info("Building frontend with Webpack")
    System.cmd("npm", ["build"], cd: @assets)

    Logger.info("Frontend build done")
  end
end
