defmodule Diacritical.Context.Account do
  @moduledoc "Defines a `Phoenix` context."
  @moduledoc since: "0.17.0"

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Context
  alias Diacritical.Repo
  alias DiacriticalSchema.Account

  alias Account.Token

  @typedoc "Represents the token data."
  @typedoc since: "0.17.0"
  @type token_data() :: Token.token_data()

  @typedoc "Represents the token type."
  @typedoc since: "0.17.0"
  @type token_type() :: Token.token_type()

  @typedoc "Represents the query count."
  @typedoc since: "0.17.0"
  @type query_count() :: {non_neg_integer(), nil | [term()]}

  @typedoc "Represents the email address."
  @typedoc since: "0.17.0"
  @type email() :: Account.email()

  @typedoc "Represents the potential account."
  @typedoc since: "0.17.0"
  @type maybe_account() :: Account.maybe_schema()

  @typedoc "Represents the password."
  @typedoc since: "0.17.0"
  @type password() :: Account.password()

  @typedoc "Represents the account."
  @typedoc since: "0.17.0"
  @type account() :: Account.t()

  @typedoc "Represents the account parameter."
  @typedoc since: "0.17.0"
  @type param() :: Account.param()

  @typedoc "Represents the account confirmation."
  @typedoc since: "0.17.0"
  @type conf() :: Context.conf(Account.changeset(), account())

  @typedoc "Represents the token confirmation."
  @typedoc since: "0.17.0"
  @type conf_token() :: Context.conf(Token.changeset(), Token.t())

  @doc """
  Deletes a token with the given `data` and `type` from the data store.

  ## Examples

      iex> checkout_repo()
      iex> %{token: %{built: %{data: data, type: type}}} = c_token(%{})
      iex>
      iex> delete_token_by_data_and_type(data, type)
      {0, nil}

      iex> checkout_repo()
      iex> %{token: %{loaded: %{data: data, type: type}}} = c_token(%{})
      iex>
      iex> delete_token_by_data_and_type(data, type)
      {1, nil}

  """
  @doc since: "0.17.0"
  @spec delete_token_by_data_and_type(token_data(), token_type()) ::
          query_count()
  def delete_token_by_data_and_type(data, type)
      when is_binary(data) and is_binary(type) do
    Token
    |> Token.query(%{filter: %{where_data_type: {data, type}}})
    |> Repo.delete_all()
  end

  @doc """
  Fetches an account from the data store by the given `email`.

  ## Examples

      iex> checkout_repo()
      iex> %{account: %{built: account}} = c_account()
      iex>
      iex> get_by_email(account.email)
      nil

      iex> checkout_repo()
      iex> %{account: %{loaded: account}} = c_account_loaded(%{})
      iex>
      iex> get_by_email(account.email)
      account

  """
  @doc since: "0.17.0"
  @spec get_by_email(email()) :: maybe_account()
  def get_by_email(email) when is_binary(email) do
    Repo.get_by(Account, email: email)
  end

  @doc """
  Fetches an account from the data store by the given `email` and `password`.

  ## Examples

      iex> checkout_repo()
      iex> %{password: %{incorrect: password}} = c_password()
      iex> %{account: %{loaded: account}} = c_account_loaded(%{})
      iex>
      iex> get_by_email_and_password(account.email, password)
      nil

      iex> checkout_repo()
      iex> %{password: %{correct: password}} = c_password()
      iex> %{account: %{loaded: account}} = c_account_loaded(%{})
      iex>
      iex> get_by_email_and_password(account.email, password)
      account

  """
  @doc since: "0.17.0"
  @spec get_by_email_and_password(email(), password()) :: maybe_account()
  def get_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    account = get_by_email(email)

    if Account.valid_password?(account, password) do
      account
    end
  end

  @doc """
  Fetches an account from the data store by the given token `data` and `type`.

  ## Examples

      iex> checkout_repo()
      iex> %{token: %{built: %{data: data, type: type}}} = c_token(%{})
      iex>
      iex> get_by_token_data_and_type(data, type)
      nil

      iex> checkout_repo()
      iex> %{token: %{loaded: %{data: data, type: type}}} = c_token(%{})
      iex>
      iex> %DiacriticalSchema.Account{} = get_by_token_data_and_type(data, type)

  """
  @doc since: "0.17.0"
  @spec get_by_token_data_and_type(token_data(), token_type()) ::
          maybe_account()
  def get_by_token_data_and_type(data, type)
      when is_binary(data) and is_binary(type) do
    arg = %{filter: %{where_data_type: {data, type}}, select: :account}

    Token
    |> Token.query(arg)
    |> Repo.one()
  end

  @doc """
  Inserts an account with the given `param` into the data store.

  ## Examples

      iex> checkout_repo()
      iex> c = c_password()
      iex> %{param: %{err: param}} = c_param_account(c)
      iex>
      iex> {:error, %Ecto.Changeset{}} = insert(param)

      iex> checkout_repo()
      iex> c = c_password()
      iex> %{param: %{atom: param}} = c_param_account(c)
      iex>
      iex> {:ok, %DiacriticalSchema.Account{}} = insert(param)

  """
  @doc since: "0.17.0"
  @spec insert(param()) :: conf()
  def insert(param) when is_map(param) do
    param
    |> Account.changeset()
    |> Repo.insert()
  end

  @doc """
  Inserts a token with the given `account` and `type` into the data store.

  ## Examples

      iex> checkout_repo()
      iex> %{account: %{built: account}} = c_account()
      iex> %{param: %{atom: %{type: type}}} = c_param_token()
      iex>
      iex> {:error, %Ecto.Changeset{}} = insert_token(account, type)

      iex> checkout_repo()
      iex> %{account: %{loaded: account}} = c_account_loaded(%{})
      iex> %{param: %{atom: %{type: type}}} = c_param_token()
      iex>
      iex> {:ok, %Token{}} = insert_token(account, type)

  """
  @doc since: "0.17.0"
  @spec insert_token(account(), token_type()) :: conf_token()
  def insert_token(%Account{id: id}, type)
      when (is_binary(id) or is_nil(id)) and is_binary(type) do
    %{account_id: id, data: :crypto.strong_rand_bytes(32), type: type}
    |> Token.changeset()
    |> Repo.insert()
  end
end
