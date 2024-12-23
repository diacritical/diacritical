defmodule DiacriticalCase.View do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.5.0"

  use DiacriticalCase

  alias Diacritical
  alias DiacriticalCase

  require Floki

  @typedoc "Represents the html."
  @typedoc since: "0.20.0"
  @type html() :: binary() | Floki.html_tree()

  @typedoc "Represents the selector."
  @typedoc since: "0.20.0"
  @type selector() :: Floki.html_node() | Floki.css_selector()

  @typedoc "Represents the context."
  @typedoc since: "0.5.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.5.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @doc """
  Asserts that the given `element` is inside the given `html` tree or string.

  ## Example

      iex> html = "<span>Hello, world!</span>"
      iex> element = "span"
      iex>
      iex> assert_element html, element
      true

  """
  @doc since: "0.20.0"
  @spec assert_element(html(), selector()) :: boolean()
  def assert_element(html, selector) when is_binary(html) do
    with {:ok, document} <- Floki.parse_document(html) do
      assert_element(document, selector)
    end
  end

  def assert_element(html, selector)
      when is_list(html) or Floki.is_html_node(html) do
    assert Floki.find(html, selector) != []
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{assigns: _assigns} = c_assigns_empty()

  """
  @doc since: "0.6.0"
  @spec c_assigns_empty() :: context_merge()
  @spec c_assigns_empty(context()) :: context_merge()
  def c_assigns_empty(c \\ %{}) when is_map(c), do: %{assigns: %{}}

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{assigns: _assigns} = c_assigns_greeting()

  """
  @doc since: "0.5.0"
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

      iex> %{resp_body: _resp_body} = c_resp_body_dismiss()

  """
  @doc since: "0.6.0"
  @spec c_resp_body_dismiss() :: context_merge()
  @spec c_resp_body_dismiss(context()) :: context_merge()
  def c_resp_body_dismiss(c \\ %{}) when is_map(c) do
    %{resp_body: "Goodbye, world!\n"}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{resp_body: _resp_body} = c_resp_body_greet()

  """
  @doc since: "0.5.0"
  @spec c_resp_body_greet() :: context_merge()
  @spec c_resp_body_greet(context()) :: context_merge()
  def c_resp_body_greet(c \\ %{}) when is_map(c) do
    %{resp_body: "#{Diacritical.greet()}\n"}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{selector: _selector} = c_selector_span(%{})

  """
  @doc since: "0.20.0"
  @spec c_selector_span(context()) :: context_merge()
  def c_selector_span(c \\ %{}) when is_map(c), do: %{selector: "span"}

  using do
    quote do
      import unquote(__MODULE__)
      import Phoenix.Component, only: [sigil_H: 2]
      import Phoenix.LiveViewTest
    end
  end
end
