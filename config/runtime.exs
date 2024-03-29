import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/portserver start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :portserver, PortserverWeb.Endpoint, server: true
end

if config_env() == :prod do
  # Configuring the database

  raise_missing_db_vars = fn ->
    raise """
    One or more of the following environment variables are missing:

    - DB_USER
    - DB_PASS
    - DB_HOST
    - DB_NAME
    """
  end

  database_url = fn ->
    username = System.get_env("DB_USER" || raise_missing_db_vars.())
    password = System.get_env("DB_PASS" || raise_missing_db_vars.())
    database = System.get_env("DB_NAME" || raise_missing_db_vars.())
    hostname = System.get_env("DB_HOST" || raise_missing_db_vars.())

    "postgresql://#{username}:#{password}@#{hostname}/#{database}"
  end

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :portserver, Portserver.Repo,
    # ssl: true,
    url: database_url.(),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  origin = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :portserver, PortserverWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## SSL Support
  #
  # To get SSL working, you will need to add the `https` key
  # to your endpoint configuration:
  #
  #     config :portserver, PortserverWeb.Endpoint,
  #       https: [
  #         ...,
  #         port: 443,
  #         cipher_suite: :strong,
  #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
  #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
  #       ]
  #
  # The `cipher_suite` is set to `:strong` to support only the
  # latest and more secure SSL ciphers. This means old browsers
  # and clients may not be supported. You can set it to
  # `:compatible` for wider support.
  #
  # `:keyfile` and `:certfile` expect an absolute path to the key
  # and cert in disk or a relative path inside priv, for example
  # "priv/ssl/server.key". For all supported SSL configuration
  # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
  #
  # We also recommend setting `force_ssl` in your endpoint, ensuring
  # no data is ever sent via http, always redirecting to https:
  #
  #     config :portserver, PortserverWeb.Endpoint,
  #       force_ssl: [hsts: true]
  #
  # Check `Plug.SSL` for all available options in `force_ssl`.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :portserver, Portserver.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

  config :portserver, :database_storage_config,
    cloak_key:
      System.get_env("CLOAK_KEY") ||
        raise( """
          environment variable CLOAK_KEY is missing.
          This key is used to encrypt doanated data at rest 
        """),
    admin_email:
      System.get_env("ADMIN_EMAIL") ||
        raise( """
          environment variable ADMIN_PASSWORD is missing.
        """),
    admin_password:
      System.get_env("ADMIN_PASSWORD") ||
        raise("""
          environment variable ADMIN_PASSWORD is missing.
        """)

  # Storage backend specific settings
  # Possible storage backends
  #
  # - Portserver.StorageBackend.YodaStorage
  # - Portserver.StorageBackend.DatabaseStorage
  # - Portserver.StorageBackend.LocalStorage
  # - Portserver.StorageBackend.AzureStorageBackend

  config = Application.get_env(:portserver, :storage_method)
  storage_method =  config[:method]

  # Yoda storage backend configuration
  if storage_method == Portserver.StorageBackend.YodaStorage do
    config :portserver, :yoda_storage_config,
      url:
        System.get_env("YODA_URL") ||
          raise( """
            environment variable YODA_URL is missing.
            example: https://facultyabreviation.data.universityabreviation.tld/my-repo/
          """),
      username:
        System.get_env("YODA_USERNAME") ||
          raise( """
            environment variable YODA_USERNAME is missing.
          """),
      password:
        System.get_env("YODA_PASSWORD") ||
          raise("""
            environment variable YODA_PASSWORD is missing.
          """)
  end

  # Azure storage backend
  if storage_method == Portserver.StorageBackend.AzureStorage do
    config :portserver, :azure_storage_config,
      storage_account_name:
        System.get_env("STORAGE_ACCOUNT_NAME") || raise("STORAGE_ACCOUNT_NAME missing"),
      container:
        System.get_env("CONTAINER_NAME") || raise("CONTAINER_NAME missing"),
      sas_token:
        System.get_env("SAS_TOKEN") || raise("SAS_TOKEN MISSING")
  end
end
