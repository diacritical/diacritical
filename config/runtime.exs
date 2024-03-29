import Config, only: [config_env: 0, config: 2, config: 3]

alias Diacritical
alias DiacriticalWeb

alias Diacritical.Mailer
alias Diacritical.Repo
alias DiacriticalWeb.Endpoint

if config_env() == :prod do
  config :argon2_elixir, t_cost: 32, m_cost: 14, parallelism: 2

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      The environment variable `SECRET_KEY_BASE` has not been set.
      You can generate a secret key base by calling `mix phx.gen.secret`.
      """

  config :diacritical, Endpoint, secret_key_base: secret_key_base

  postmark_api_key =
    System.get_env("POSTMARK_API_KEY") ||
      raise """
      The environment variable `POSTMARK_API_KEY` has not been set.
      The value should be a valid Postmark API token.
      """

  config :diacritical, Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: postmark_api_key

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      The environment variable `DATABASE_URL` has not been set.
      The value should be a valid PostgreSQL connection string.
      """

  config :diacritical, Repo, url: database_url

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
