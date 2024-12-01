import Config, only: [config: 2, config: 3]

alias DiacriticalWeb

alias DiacriticalWeb.Endpoint

config :diacritical, Endpoint,
  adapter: Bandit.PhoenixAdapter,
  force_ssl: [
    expires: 63_072_000,
    host: nil,
    preload: true,
    rewrite_on: ~W[x_forwarded_host x_forwarded_port x_forwarded_proto]a,
    subdomains: true
  ],
  http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: 4_000],
  https: [
    certfile: "priv/diacritical_web/cert/selfsigned.pem",
    cipher_suite: :strong,
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    keyfile: "priv/diacritical_web/cert/selfsigned_key.pem",
    otp_app: :diacritical,
    port: 4_001
  ],
  pubsub_server: :"Elixir.Diacritical.PubSub",
  render_errors: nil,
  secret_key_base:
    "rHHk51MXiuewZ3FpqbHMHso7zRMqFYN8sPGAVNJ0Y956svsgKntwfdrOKxM6WCMa",
  server: true,
  url: [host: nil, path: "/", port: 443, scheme: "https"]

config :diacritical, env: [prod: true]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, level: :info
config :phoenix, :json_library, Jason
