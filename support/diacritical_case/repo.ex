defmodule DiacriticalCase.Repo do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.11.0"

  use DiacriticalCase

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Account

  @typedoc "Represents the context."
  @typedoc since: "0.11.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.11.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{account: _account} = c_account()

  """
  @doc since: "0.17.0"
  @spec c_account() :: context_merge()
  @spec c_account(context()) :: context_merge()
  def c_account(c \\ %{}) when is_map(c) do
    email = "jdoe@example.com"
    password = c[:password][:correct] || "correct horse battery staple"
    password_digest = Argon2.hash_pwd_salt(password)

    %{
      account: %{
        built: %Account{email: email, password_digest: password_digest},
        invalid: %{email: ~c"#{email}", password_digest: password_digest},
        missing: nil
      }
    }
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{password: _password} = c_password()

  """
  @doc since: "0.17.0"
  @spec c_password() :: context_merge()
  @spec c_password(context()) :: context_merge()
  def c_password(c \\ %{}) when is_map(c) do
    password = "correct horse battery staple"

    %{
      password: %{
        correct: password,
        invalid: ~c"#{password}",
        incorrect: "hunter2",
        missing: nil
      }
    }
  end

  @doc """
  Checks out a connection to the sandbox pool for `Diacritical.Repo`.

  ## Example

      iex> checkout_repo()
      :ok

  """
  @doc since: "0.11.0"
  @spec checkout_repo() :: context_merge()
  @spec checkout_repo(context()) :: context_merge()
  def checkout_repo(c \\ %{}) when is_map(c) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  using do
    quote do
      import Ecto.Query, only: [from: 2]
      import unquote(__MODULE__)
    end
  end
end
