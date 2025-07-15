import Config, only: [config: 2, import_config: 1]

import_config "prod.exs"

config :diacritical, env: [test: true]
config :logger, level: :warning
config :os_mon, start_cpu_sup: false, start_disksup: false, start_memsup: false
