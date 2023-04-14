defmodule Mix.Tasks.BuildFrontend do
  @moduledoc "This task runs the builds the frontend with npm"
  @shortdoc "Build frontend"
  use Mix.Task
  require Logger

  @assets "assets"

  def run(_) do
    Logger.info("Installing NPM packages")
    System.cmd("npm", ["install"], cd: assets_dir())

    Logger.info("Building frontend with Webpack")
    System.cmd("npm", ["run", "build"], cd: assets_dir())

    Logger.info("Frontend build done")
  end

  defp assets_dir() do
    Path.join(File.cwd!(), @assets)
  end
end
