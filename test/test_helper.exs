alias Diacritical

alias Diacritical.Repo
alias Diacritical.RepoTest

ExUnit.start(exclude: [module: RepoTest, supervisor: Repo])
Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)
