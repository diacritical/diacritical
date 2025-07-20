import Config, only: [config: 2, config: 3, import_config: 1]

alias DiacriticalWeb

alias DiacriticalWeb.Endpoint

import_config "prod.exs"

config :diacritical, Endpoint,
  http: [port: 4_002],
  https: [port: 4_003],
  url: [host: "localhost", path: "/", port: 4_003, scheme: "https"]

config :diacritical, env: [test: true]
config :logger, level: :warning
config :os_mon, start_cpu_sup: false, start_disksup: false, start_memsup: false
config :phoenix, :plug_init_mode, :runtime
