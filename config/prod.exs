import Config, only: [config: 2, config: 3]

config :diacritical, env: [prod: true]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, level: :info
