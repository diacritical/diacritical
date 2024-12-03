alias Diacritical
alias DiacriticalSchema
alias DiacriticalSchema.Account

alias Diacritical.Repo
alias DiacriticalSchema.TestSchema

if Mix.env() in [:dev, :test] and not Repo.exists?(TestSchema) do
  Repo.insert_all(TestSchema, Enum.map(1_001..2_000, &%{x: :rand.uniform(&1)}))
end

if Mix.env() in [:dev, :test] and not Repo.exists?(Account) do
  Repo.insert_all(
    Account,
    Enum.map(
      1..1_000,
      fn _entry ->
        %{
          confirmed_at: DateTime.add(DateTime.utc_now(), 15),
          email: "jdoe+#{System.unique_integer([:positive])}@example.com",
          password_digest: Argon2.hash_pwd_salt("correct horse battery staple")
        }
      end
    )
  )
end
