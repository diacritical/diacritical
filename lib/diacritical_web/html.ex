defmodule DiacriticalWeb.HTML do
  @moduledoc "Defines commonalities for `Phoenix.Template` templates."
  @moduledoc since: "0.6.0"

  alias DiacriticalWeb

  alias DiacriticalWeb.Token

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

      converter = fn pattern ->
        pattern
        |> Path.basename()
        |> Path.rootname(".html.heex")
      end

      Phoenix.Template.compile_all(
        converter,
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
      iex> c = c_resp_body_greet()
      iex> %{resp_body: resp_body} = c_resp_body_to_html(c)
      iex>
      iex> function_exported?(TestTemplate, :greet, 1)
      true
      iex> render_component(&TestTemplate.greet/1, assigns)
      resp_body

  """
  @doc since: "0.6.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.static_path()

      import unquote(__MODULE__)
      import Phoenix.Component, except: [embed_templates: 1, embed_templates: 2]
      import Phoenix.Controller, only: [get_csrf_token: 0]
      import Phoenix.HTML
      import Token, only: [sign: 1]
    end
  end
end
