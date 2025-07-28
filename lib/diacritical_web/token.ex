defmodule DiacriticalWeb.Token do
  @moduledoc "Defines a `Phoenix.Token` wrapper."
  @moduledoc since: "0.6.0"

  alias DiacriticalWeb

  alias DiacriticalWeb.Endpoint

  @typedoc "Represents the data."
  @typedoc since: "0.6.0"
  @type data() :: term()

  @typedoc "Represents the token."
  @typedoc since: "0.6.0"
  @type token() :: binary()

  @typedoc "Represents the potential token."
  @typedoc since: "0.6.0"
  @type maybe_token() :: nil | token()

  @typedoc "Represents the error given by the verification."
  @typedoc since: "0.6.0"
  @type verification_err() :: :expired | :invalid | :missing

  @typedoc "Represents the verification."
  @typedoc since: "0.6.0"
  @type verification() :: {:error, verification_err()} | {:ok, data()}

  @namespace "diacritical"

  @doc """
  Encodes and signs the given `data` into a bearer token.

  ## Example

      iex> %{data: data} = c_data(%{})
      iex>
      iex> sign(data) =~ "SFMyNTY"
      true

  """
  @doc since: "0.6.0"
  @spec sign(data()) :: token()
  def sign(data) do
    Phoenix.Token.sign(Endpoint, @namespace, data)
  end

  @doc """
  Decodes the original data from a given `token` and verifies its integrity.

  ## Examples

      iex> %{data: data} = c_data(%{})
      iex> opt = [signed_at: System.system_time(:second) - 604_800]
      iex> token = Phoenix.Token.sign(Endpoint, "diacritical", data, opt)
      iex>
      iex> verify(token)
      {:error, :expired}

      iex> verify("")
      {:error, :invalid}

      iex> verify(nil)
      {:error, :missing}

      iex> %{data: data} = c_data(%{})
      iex> token = Phoenix.Token.sign(Endpoint, "diacritical", data)
      iex>
      iex> verify(token)
      {:ok, data}

  """
  @doc since: "0.6.0"
  @spec verify(maybe_token()) :: verification()
  def verify(maybe_token) when is_binary(maybe_token) or is_nil(maybe_token) do
    Phoenix.Token.verify(Endpoint, @namespace, maybe_token)
  end
end
