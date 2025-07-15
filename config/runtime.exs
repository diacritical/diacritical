import Config, only: [config: 3]

config :diacritical, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")
