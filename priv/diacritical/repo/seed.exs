alias Diacritical
alias DiacriticalSchema

alias Diacritical.Repo
alias DiacriticalSchema.TestSchema

if Mix.env() in [:dev, :test] and not Repo.exists?(TestSchema) do
  Repo.insert_all(TestSchema, Enum.map(1_001..2_000, &%{x: :rand.uniform(&1)}))
end
