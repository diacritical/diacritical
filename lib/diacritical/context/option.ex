defmodule Diacritical.Context.Option do
  @moduledoc "Defines a `Phoenix` context."
  @moduledoc since: "0.23.0"

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Option

  @typedoc "Represents the option."
  @typedoc since: "0.23.0"
  @type option() :: Option.t()

  @typedoc "Represents the option list."
  @typedoc since: "0.23.0"
  @type option_list() :: [option()]

  @doc """
  Fetches the option list from the data store.

  ## Example

      iex> checkout_repo()
      iex>
      iex> [%DiacriticalSchema.Option{} | _option] = all()

  """
  @doc since: "0.23.0"
  @spec all() :: option_list()
  def all() do
    Repo.all(Option)
  end
end
