alias Diacritical

alias Diacritical.Repo

ExUnit.start(exclude: [supervisor: Repo])
Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)
