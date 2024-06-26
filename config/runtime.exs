import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Start the phoenix server
config :nuca_backend, NucaBackendWeb.Endpoint, server: true

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :nuca_backend, NucaBackend.Repo,
    ssl: true,
    url: database_url,
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

  host = System.fetch_env!("NUCA_BACKEND_HOST")
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :nuca_backend, NucaBackendWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      port: port
    ],
    https: [
      port: 443,
      cipher_suite: :strong,
      keyfile: System.fetch_env!("NUCA_SSL_KEY_PATH"),
      certfile: System.fetch_env!("NUCA_SSL_CERT_PATH"),
      cacertfile: System.fetch_env!("NUCA_SSL_CA_CERT_PATH"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base

  config :waffle,
    storage: Waffle.Storage.S3,
    bucket: System.fetch_env!("NUCA_S3_BUCKET"),
    virtual_host: true

  config :ex_aws,
    access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY"),
    region: "eu-west-1",
    host: "s3.eu-west-1.amazonaws.com",
    s3: [
      scheme: "https://",
      host: "s3.eu-west-1.amazonaws.com",
      region: "eu-west-1"
    ]

  config :nuca_backend,
    local_temp_dir: System.get_env("NUCA_UPLOADS_TEMP_DIR") || "uploads_temp"

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :nuca_backend, NucaBackendWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :nuca_backend, NucaBackend.Mailer,
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
end
