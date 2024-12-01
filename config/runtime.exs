import Config, only: [config_env: 0, config: 3]

alias DiacriticalWeb

alias DiacriticalWeb.Endpoint

config :diacritical, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      The environment variable `SECRET_KEY_BASE` has not been set.
      """

  config :diacritical, Endpoint, secret_key_base: secret_key_base
end
