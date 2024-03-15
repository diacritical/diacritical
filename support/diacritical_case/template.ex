defmodule DiacriticalCase.Template do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.5.0"

  use DiacriticalCase

  alias DiacriticalCase

  @typedoc "Represents the context."
  @typedoc since: "0.5.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.5.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{context: _context} = c_context()

  """
  @doc since: "0.5.0"
  @spec c_context() :: context_merge()
  @spec c_context(context()) :: context_merge()
  def c_context(c \\ %{}) when is_map(c) do
    %{context: %{invalid: [], valid: %{}}}
  end

  using do
    quote do
      import unquote(__MODULE__)
    end
  end
end
