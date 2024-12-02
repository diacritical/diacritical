alias Diacritical
alias DiacriticalSchema

alias Diacritical.Repo
alias DiacriticalSchema.TestSchema

ExUnit.start(exclude: [schema: TestSchema, supervisor: Repo])
Ecto.Adapters.SQL.Sandbox.mode(Repo, :manual)
