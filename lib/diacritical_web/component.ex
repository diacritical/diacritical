defmodule DiacriticalWeb.Component do
  @moduledoc "Defines commonalities for `Phoenix.Component` components."
  @moduledoc since: "0.21.0"

  @doc """
  In `use`, calls `use Phoenix.Component`.

  ## Example

      iex> defmodule TestComponent do
      ...>   use DiacriticalWeb.Component
      ...>
      ...>   attr :greeting, :string, required: true
      ...>
      ...>   def greet(assigns) when is_map(assigns) do
      ...>     ~H"<span>{@greeting}</span>"
      ...>   end
      ...> end
      iex>
      iex> %{assigns: %{valid: assigns}} = c_assigns_greeting()
      iex> render = render_component(&TestComponent.greet/1, assigns)
      iex> %{selector: selector} = c_selector_span()
      iex>
      iex> TestComponent.__components__()
      %{
        greet: %{
          attrs: [
            %{
              doc: nil,
              line: 13,
              name: :greeting,
              opts: [],
              required: true,
              slot: nil,
              type: :string
            }
          ],
          line: 15,
          kind: :def,
          slots: []
        }
      }
      iex> assert_element render, selector
      true

  """
  @doc since: "0.21.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Gettext, backend: Diacritical.Gettext

      use Phoenix.Component, unquote(opt)

      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.static_path()
    end
  end
end
