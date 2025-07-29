import Config, only: [config: 2, config: 3]

alias DiacriticalWeb

alias DiacriticalWeb.Endpoint
alias DiacriticalWeb.HTML
alias DiacriticalWeb.TXT

config :diacritical, Endpoint,
  adapter: Bandit.PhoenixAdapter,
  cache_static_manifest: "priv/diacritical_web/static/cache_manifest.json",
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
  render_errors: [
    formats: [html: HTML.Error, txt: TXT.Error],
    layout: [html: {HTML.Layout, :main}],
    root_layout: [html: {HTML.Layout, :root}]
  ],
  secret_key_base:
    "TMK8Q5EFfQlxa6k4bt02uplsaTf0gDLu0O8B3F8HukfaPXqBIgoXZVURXIbAMKLn",
  server: true,
  url: [host: nil, path: "/", port: 443, scheme: "https"]

config :diacritical, env: [prod: true]

config :esbuild,
  diacritical_web: [
    args: [
      "index.css",
      "index.js",
      "vendor/inter/index.css",
      "--loader:.woff2=file",
      "--bundle",
      "--target=chrome109,edge109,firefox109,safari16.3",
      "--outdir=../../priv/diacritical_web/static/asset"
    ],
    cd: Path.expand("../asset/diacritical_web", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../dep", __DIR__)}
  ],
  version: "0.24.0"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger, level: :info
config :phoenix, :json_library, JSON
