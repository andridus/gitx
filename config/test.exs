import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gitx, GitxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "jjZD4/2G3gdiazOPuBJHPEMwNYdySUN1fDBMPRRamQp1dxNBhAUA7jwE/g8LgOor",
  server: false

config :gitx, webhook_id: "f855fbda-72e2-4c0c-8f67-a28146931f84"

config :gitx, Gitx.Repo,
  database: "gitx_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :gitx, Oban,
  prefix: false,
  queues: [github: 1, webhook: 10],
  repo: Gitx.Repo

# In test we don't send emails.
config :gitx, Gitx.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
