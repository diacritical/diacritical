import Config, only: [config: 2, config: 3]

alias Diacritical
alias DiacriticalWeb

alias Diacritical.Repo
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
  live_view: [signing_salt: "g1TNgaS1geI9gO95"],
  pubsub_server: :"Elixir.Diacritical.PubSub",
  render_errors: [
    formats: [html: HTML.Error, txt: TXT.Error],
    layout: [html: {HTML.Layout, :app}],
    root_layout: [html: {HTML.Layout, :root}]
  ],
  secret_key_base:
    "NtJ2ZriOUZtZl95rk6LxwUgSvP8kP5mJPo4JgnzQwzxwiz7rrArS0Ai5sjPy085G",
  session: [
    key: "__Host-session",
    same_site: "Strict",
    signing_salt: "t4wyQYyIRqY53Mgx",
    store: :cookie
  ],
  server: true,
  url: [host: nil, path: "/", port: 443, scheme: "https"]

config :diacritical, Repo,
  after_connect: {Postgrex, :query!, ["SET timezone TO UTC", []]},
  database: "diacritical",
  migration_source: "schema_migration",
  priv: "priv/diacritical/repo",
  socket_options: [:inet6]

config :diacritical, ecto_repos: [Repo]
config :diacritical, env: [prod: true]

config :esbuild,
  diacritical_web: [
    args: [
      "css/app.css",
      "js/app.js",
      "vendor/inter/inter.css",
      "--loader:.woff2=file",
      "--bundle",
      "--target=es2020,chrome87,edge88,firefox78,safari14",
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
config :phoenix, :json_library, Jason
