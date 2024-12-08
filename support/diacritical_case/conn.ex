defmodule DiacriticalCase.Conn do
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

      iex> %{conn: _conn} = c_conn()

  """
  @doc since: "0.5.0"
  @spec c_conn() :: context_merge()
  @spec c_conn(context()) :: context_merge()
  def c_conn(c \\ %{request_path: "/"}) when is_map(c) do
    %{
      conn: %{
        invalid: %{},
        valid:
          Phoenix.ConnTest.build_conn(
            :get,
            c[:uri][:string] || c[:request_path]
          )
      }
    }
  end

  using do
    quote do
      import unquote(__MODULE__)
      import DiacriticalCase.View
      import Phoenix.ConnTest

      @endpoint DiacriticalWeb.Endpoint
    end
  end
end
