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
    %{assigns: %{invalid: {}, valid: %{}}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{assigns: _assigns} = c_assigns_greeting()

  """
  @doc since: "0.6.0"
  @spec c_assigns_greeting() :: context_merge()
  @spec c_assigns_greeting(context()) :: context_merge()
  def c_assigns_greeting(c \\ %{}) when is_map(c) do
    %{assigns: %{invalid: {}, valid: %{greeting: Diacritical.greet()}}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body_404()

  """
  @doc since: "0.6.0"
  @spec c_resp_body_404() :: context_merge()
  @spec c_resp_body_404(context()) :: context_merge()
  def c_resp_body_404(c \\ %{}) when is_map(c) do
    %{resp_body: "Not Found\n"}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body_500()

  """
  @doc since: "0.6.0"
  @spec c_resp_body_500() :: context_merge()
  @spec c_resp_body_500(context()) :: context_merge()
  def c_resp_body_500(c \\ %{}) when is_map(c) do
    %{resp_body: "Internal Server Error\n"}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body_dismissal()

  """
  @doc since: "0.6.0"
  @spec c_resp_body_dismissal() :: context_merge()
  @spec c_resp_body_dismissal(context()) :: context_merge()
  def c_resp_body_dismissal(c \\ %{}) when is_map(c) do
    %{resp_body: "Goodbye, world!\n"}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body_greeting()

  """
  @doc since: "0.5.0"
  @spec c_resp_body_greeting() :: context_merge()
  @spec c_resp_body_greeting(context()) :: context_merge()
  def c_resp_body_greeting(c \\ %{}) when is_map(c) do
    %{resp_body: "#{Diacritical.greet()}\n"}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body_to_html(%{resp_body: ""})

  """
  @doc since: "0.6.0"
  @spec c_resp_body_to_html(context()) :: context_merge()
  def c_resp_body_to_html(%{resp_body: resp_body}) when is_binary(resp_body) do
    %{resp_body: {:safe, ["<span>", String.trim(resp_body), "</span>\n"]}}
  end

  using do
    quote do
      import unquote(__MODULE__)
      import Phoenix.HTML, only: [safe_to_string: 1]
    end
  end
end
