import Config, only: [config: 2, config: 3, config_env: 0]

alias Diacritical
alias DiacriticalWeb

alias Diacritical.Mailer
alias Diacritical.Repo
alias DiacriticalWeb.Endpoint

config :diacritical, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

if config_env() == :prod do
  config :argon2_elixir, m_cost: 16, parallelism: 1, t_cost: 8

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      The environment variable `SECRET_KEY_BASE` has not been set.
      """

  config :diacritical, Endpoint, secret_key_base: secret_key_base

  postmark_api_key =
    System.get_env("POSTMARK_API_KEY") ||
      raise """
      The environment variable `POSTMARK_API_KEY` has not been set.
      """

  config :diacritical, Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: postmark_api_key

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      The environment variable `DATABASE_URL` has not been set.
      """

  config :diacritical, Repo, url: database_url
end
