import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :swapex, SwapexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "jjZD4/2G3gdiazOPuBJHPEMwNYdySUN1fDBMPRRamQp1dxNBhAUA7jwE/g8LgOor",
  server: false

config :swapex, Swapex.Repo,
  database: Path.expand("../db/swapex_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :swapex, Oban,
  engine: Oban.Engines.Lite,
  prefix: false,
  queues: [github: 1, webhook: 10],
  repo: Swapex.Repo

# In test we don't send emails.
config :swapex, Swapex.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
