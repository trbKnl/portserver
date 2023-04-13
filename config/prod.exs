import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :portserver, PortserverWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Portserver.Finch

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

# Database storage backend configuration 
config :portserver, :database_storage_config,
  cloak_key: "swUo//sEExnV6VcK4TtSmKWSjQj5RWZSSzCpRlYCcjE="

# Portserver specific configuration
# Local storage backend configuration
config :portserver, :local_storage_config,
  storage_directory: "./donated_data"
