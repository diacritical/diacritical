import Config, only: [config: 2, import_config: 1]

import_config "test.exs"

config :diacritical, env: [dev: true]
config :logger, level: :debug
config :os_mon, start_cpu_sup: true, start_disksup: true, start_memsup: true
