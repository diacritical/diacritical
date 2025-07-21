defmodule DiacriticalCase.View do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.5.0"

  use DiacriticalCase

  alias Diacritical
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

      iex> %{assigns: _assigns} = c_assigns()

  """
  @doc since: "0.5.0"
  @spec c_assigns() :: context_merge()
  @spec c_assigns(context()) :: context_merge()
  def c_assigns(c \\ %{}) when is_map(c) do
    %{assigns: %{invalid: {}, valid: %{greeting: Diacritical.greet()}}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body()

  """
  @doc since: "0.5.0"
  @spec c_resp_body() :: context_merge()
  @spec c_resp_body(context()) :: context_merge()
  def c_resp_body(c \\ %{}) when is_map(c) do
    %{resp_body: "#{Diacritical.greet()}\n"}
  end

  using do
    quote do
      import unquote(__MODULE__)
    end
  end
end
