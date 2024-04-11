defmodule DiacriticalWeb.Component do
  @moduledoc "Defines `Phoenix.Component` components."
  @moduledoc since: "0.21.0"

  alias Diacritical

  alias Diacritical.I18n

  @doc """
  In `use`, calls `use Phoenix.Component`.

  ## Example

      iex> defmodule TestComponent do
      ...>   use DiacriticalWeb.Component
      ...>
      ...>   attr :greeting, :string, required: true
      ...>
      ...>   def greet(assigns) do
      ...>     ~H\"""
      ...>     <span><%= @greeting %></span>
      ...>     \"""
      ...>   end
      ...> end
      iex>
      iex> %{assigns: %{valid: assigns}} = c_assigns_greeting()
      iex> render = render_component(&TestComponent.greet/1, assigns)
      iex>
      iex> TestComponent.__components__()
      %{
        greet: %{
          attrs: [
            %{
              doc: nil,
              line: 17,
              name: :greeting,
              opts: [],
              required: true,
              slot: nil,
              type: :string
            }
          ],
          line: 19,
          kind: :def,
          slots: []
        }
      }
      iex> assert_element render, "span"
      true

  """
  @doc since: "0.21.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Phoenix.Component

      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.static_path()

      import I18n
    end
  end
end
