import Config, only: [config: 2, config: 3, import_config: 1]

alias DiacriticalWeb

alias DiacriticalWeb.Endpoint

import_config "test.exs"

config :diacritical, Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  http: [port: 4_004],
  https: [port: 4_005],
  url: [host: "localhost", path: "/", port: 4_005, scheme: "https"]

config :diacritical, env: [dev: true]
config :logger, level: :debug
config :os_mon, start_cpu_sup: true, start_disksup: true, start_memsup: true
config :phoenix, :stacktrace_depth, 32
