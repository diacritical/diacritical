defmodule DiacriticalCase do
  @moduledoc "Defines commonalities for `ExUnit.CaseTemplate` case templates."
  @moduledoc since: "0.3.0"

  use Boundary, deps: [Diacritical, ExUnit, Phoenix, Plug]

  @typedoc "Represents the context."
  @typedoc since: "0.3.0"
  @type context() :: map()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.3.0"
  @type context_merge() ::
          :ok | {:ok, map() | Keyword.t()} | map() | Keyword.t()

  @doc """
  In `use`, calls `use ExUnit.CaseTemplate`.

  ## Example

      iex> defmodule TestTemplate do
      ...>   use DiacriticalCase
      ...> end
      iex>
      iex> TestTemplate.__ex_unit__(:setup, %{})
      %{}
      iex> TestTemplate.__ex_unit__(:setup_all, %{})
      %{}

  """
  @doc since: "0.3.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use ExUnit.CaseTemplate, unquote(opt)
    end
  end
end
