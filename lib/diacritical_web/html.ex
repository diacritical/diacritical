defmodule DiacriticalWeb.HTML do
  @moduledoc "Defines commonalities for `Phoenix.Template` templates."
  @moduledoc since: "0.6.0"

  @doc """
  Compiles a function for each template in the given `pattern`.

  ## Option

    * `:root` - The template root directory. If a directory is not given, it
      will, by default, be the module’s current directory, `__DIR__`.

  """
  @doc since: "0.6.0"
  defmacro embed_templates(pattern, opt \\ [])
           when is_binary(pattern) and is_list(opt) do
    quote do
      require Phoenix.Template

      derive_template = fn pattern ->
        pattern
        |> Path.basename()
        |> Path.rootname(".html.eex")
      end

      Phoenix.Template.compile_all(
        derive_template,
        Path.expand(unquote(opt)[:root] || __DIR__, __DIR__),
        "#{unquote(pattern)}.html"
      )
    end
  end

  @doc """
  In `use`, calls `import unquote(__MODULE__)` to import common functions.

  ## Example

      iex> defmodule TestTemplate do
      ...>   use DiacriticalWeb.HTML
      ...>
      ...>   embed_templates "template/*",
      ...>     root: "../../support/diacritical_web/html"
      ...> end
      iex>
      iex> %{assigns: %{valid: assigns}} = c_assigns_greeting()
      iex> c = c_resp_body_greeting()
      iex> %{resp_body: resp_body} = c_resp_body_to_html(c)
      iex>
      iex> function_exported?(TestTemplate, :greet, 1)
      true
      iex> TestTemplate.greet(assigns)
      resp_body

  """
  @doc since: "0.6.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router"

      import unquote(__MODULE__)
      import Phoenix.HTML
    end
  end
end
