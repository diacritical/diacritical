import Config, only: [config: 2, config: 3, import_config: 1]

alias Diacritical
alias DiacriticalWeb

alias Diacritical.Repo
alias DiacriticalWeb.Endpoint

import_config "prod.exs"

config :diacritical, Endpoint,
  cache_static_manifest: nil,
  http: [port: 4_002],
  https: [port: 4_003],
  url: [host: "localhost", path: "/", port: 4_003, scheme: "https"]

config :diacritical, Repo,
  database: "diacritical_test",
  hostname: "localhost",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2,
  username: "postgres"

config :diacritical, env: [test: true]
config :logger, level: :warning
config :os_mon, start_cpu_sup: false, start_disksup: false, start_memsup: false
config :phoenix, :plug_init_mode, :runtime
config :phoenix_live_view, :enable_expensive_runtime_checks, true
