import Config, only: [config_env: 0, config: 2, config: 3]

alias DiacriticalWeb

alias DiacriticalWeb.Endpoint

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      The environment variable `SECRET_KEY_BASE` has not been set.
      You can generate a secret key base by calling `mix phx.gen.secret`.
      """

  config :diacritical, Endpoint, secret_key_base: secret_key_base

  fly_app_name =
    System.get_env("FLY_APP_NAME") ||
      raise """
      The environment variable `FLY_APP_NAME` has not been set.
      This value is set by the `fly.io` runtime environment.
      """

  config :libcluster,
    topology: [
      fly6pn: [
        config: [
          node_basename: fly_app_name,
          polling_interval: 5_000,
          query: "#{fly_app_name}.internal"
        ],
        strategy: Cluster.Strategy.DNSPoll
      ]
    ]
end
