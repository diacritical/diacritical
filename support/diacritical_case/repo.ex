defmodule DiacriticalCase.Repo do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.10.0"

  use DiacriticalCase

  alias Diacritical
  alias DiacriticalCase

  alias Diacritical.Repo

  @typedoc "Represents the context."
  @typedoc since: "0.10.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.10.0"
  @type context_merge() :: DiacriticalCase.context_merge()

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
