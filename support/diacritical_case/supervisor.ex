defmodule DiacriticalCase.Supervisor do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.3.0"

  use DiacriticalCase

  alias Diacritical
  alias DiacriticalCase

  alias Diacritical.Supervisor

  @typedoc "Represents the context."
  @typedoc since: "0.3.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.3.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{err: _err} = c_err()

  """
  @doc since: "0.3.0"
  @spec c_err() :: context_merge()
  @spec c_err(context()) :: context_merge()
  def c_err(c \\ %{}) when is_map(c) do
    %{err: {:error, {:already_started, Process.whereis(Supervisor)}}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{init: _init} = c_init()

  """
  @doc since: "0.3.0"
  @spec c_init() :: context_merge()
  @spec c_init(context()) :: context_merge()
  def c_init(c \\ %{}) when is_map(c) do
    %{init: %{invalid: %{}, valid: []}}
  end

  using do
    quote do
      import unquote(__MODULE__)
    end
  end
end
