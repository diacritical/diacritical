defmodule DiacriticalCase.Repo do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.10.0"

  use DiacriticalCase

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Account

  alias Account.Token

  @typedoc "Represents the context."
  @typedoc since: "0.10.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.10.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{account: _account} = c_account()

  """
  @doc since: "0.16.0"
  @spec c_account() :: context_merge()
  @spec c_account(context()) :: context_merge()
  def c_account(c \\ %{}) when is_map(c) do
    email = "jdoe@example.com"
    %{password: %{correct: password}} = c_data_password()
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

      iex> %{email: _email} = c_data_email()

  """
  @doc since: "0.23.0"
  @spec c_data_email() :: context_merge()
  @spec c_data_email(context()) :: context_merge()
  def c_data_email(c \\ %{}) when is_map(c) do
    %{email: %{addressed: "jdoe@example.com", unaddressed: "jdoeexample.com"}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{password: _password} = c_data_password()

  """
  @doc since: "0.16.0"
  @spec c_data_password() :: context_merge()
  @spec c_data_password(context()) :: context_merge()
  def c_data_password(c \\ %{}) when is_map(c) do
    password = "correct horse battery staple"

    %{
      password: %{
        correct: password,
        incorrect: "hunter2",
        invalid: ~c"#{password}",
        missing: nil
      }
    }
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{slug: _slug} = c_data_slug()

  """
  @doc since: "0.23.0"
  @spec c_data_slug() :: context_merge()
  @spec c_data_slug(context()) :: context_merge()
  def c_data_slug(c \\ %{}) when is_map(c) do
    slug = "example"
    %{slug: %{slugified: slug, unslugified: "-#{slug}"}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{param: _param} = c_param_account()

  """
  @doc since: "0.16.0"
  @spec c_param_account() :: context_merge()
  @spec c_param_account(context()) :: context_merge()
  def c_param_account(c \\ %{}) when is_map(c) do
    %{email: %{addressed: email, unaddressed: email!}} = c_data_email()
    %{password: %{correct: password, incorrect: password!}} = c_data_password()

    %{
      param: %{
        atom: %{email: email, password: password},
        err: %{email: email!, password: password!},
        invalid: [],
        string: %{"email" => email, "password" => password}
      }
    }
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{param: _param} = c_param_token()

  """
  @doc since: "0.16.0"
  @spec c_param_token() :: context_merge()
  @spec c_param_token(context()) :: context_merge()
  def c_param_token(c \\ %{}) when is_map(c) do
    account_id = Ecto.UUID.generate()
    data = :crypto.strong_rand_bytes(32)
    %{email: %{addressed: email, unaddressed: email!}} = c_data_email()
    type = "unknown"

    %{
      param: %{
        atom: %{
          account_id: account_id,
          data: data,
          sent_to: email,
          type: type
        },
        err: %{
          account_id: ~c"#{account_id}",
          data: ~C"",
          sent_to: email!,
          type: ~c"#{type}"
        },
        invalid: [],
        string: %{
          "account_id" => account_id,
          "data" => data,
          "sent_to" => email,
          "type" => type
        }
      }
    }
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> checkout_core(%{})
      iex>
      iex> %{token: %{loaded: _token}} = c_token_loaded()

  """
  @doc since: "0.17.0"
  @spec c_token_loaded() :: context_merge()
  @spec c_token_loaded(context()) :: context_merge()
  def c_token_loaded(c \\ %{}) when is_map(c) do
    token =
      Token
      |> Token.query(%{limit: 1, order_by: :random})
      |> Repo.one()

    %{token: Map.merge(c[:token] || %{}, %{loaded: token})}
  end

  @doc """
  Checks a sandbox connection out for `Diacritical.Repo`, given the `context`.

  ## Example

      iex> checkout_repo()
      :ok

  """
  @doc since: "0.10.0"
  @spec checkout_repo() :: context_merge()
  @spec checkout_repo(context()) :: context_merge()
  def checkout_repo(c \\ %{}) when is_map(c) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  using do
    quote do
      import unquote(__MODULE__)
      import Ecto.Query, only: [from: 2]
    end
  end
end
