import Config, only: [config_env: 0, import_config: 1]

import_config "#{config_env()}.exs"
