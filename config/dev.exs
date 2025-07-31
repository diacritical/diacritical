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
  live_reload: [
    notify: [live_view: [~r/lib\/diacritical_web\/live_view\/.*(?:ex)$/]],
    patterns: [
      ~r/lib\/diacritical_web\/(?:controller|html|txt)\/.*(?:ex)$/,
      ~r/priv\/diacritical_web\/static\/.*(?:css|ico|js|svg|txt|woff2)$/
    ]
  ],
  url: [host: "localhost", path: "/", port: 4_005, scheme: "https"],
  watchers: [
    esbuild: {
      Esbuild,
      :install_and_run,
      [:diacritical_web, ["--sourcemap=inline", "--watch"]]
    }
  ]

config :diacritical, env: [dev: true]
config :logger, level: :debug
config :os_mon, start_cpu_sup: true, start_disksup: true, start_memsup: true
config :phoenix, :stacktrace_depth, 32

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_tags_annotations: true
