import Config, only: [config: 3, config_env: 0]

alias Diacritical
alias DiacriticalWeb

alias Diacritical.Repo
alias DiacriticalWeb.Endpoint

config :diacritical, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      The environment variable `SECRET_KEY_BASE` has not been set.
      """

  config :diacritical, Endpoint, secret_key_base: secret_key_base

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      The environment variable `DATABASE_URL` has not been set.
      """

  config :diacritical, Repo, url: database_url
end
