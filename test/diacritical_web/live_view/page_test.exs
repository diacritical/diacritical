defmodule DiacriticalWeb.LiveView.PageTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.8.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.HTML
  alias DiacriticalWeb.LiveView

  alias HTML.Layout
  alias LiveView.Page

  @typedoc "Represents the context."
  @typedoc since: "0.8.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.8.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_socket(context()) :: context_merge()
  defp c_socket(c) when is_map(c) do
    %{socket: %{invalid: %{}, valid: %Phoenix.LiveView.Socket{}}}
  end

  doctest Page, import: true

  describe "__components__/0" do
    import Page, only: [__components__: 0]

    test "success" do
      assert __components__() == %{}
    end
  end

  describe "__live__/0" do
    import Page, only: [__live__: 0]

    test "success" do
      assert __live__() == %{
               container: {:div, []},
               kind: :view,
               layout: {Layout, "app"},
               lifecycle: %Phoenix.LiveView.Lifecycle{
                 mount: [
                   %{
                     function: &LiveView.on_mount/4,
                     id: {LiveView, :default},
                     stage: :mount
                   }
                 ]
               },
               log: :debug
             }
    end
  end

  describe "__phoenix_verify_routes__/1" do
    import Page, only: [__phoenix_verify_routes__: 1]

    test "success" do
      assert __phoenix_verify_routes__(Page) == :ok
    end
  end

  describe "mount/3" do
    import Page, only: [mount: 3]

    setup ~W[c_param c_session c_socket]a

    test "success", %{
      param: %{valid: param},
      session: %{valid: session},
      socket: %{valid: socket}
    } do
      assert {
               :ok,
               %Phoenix.LiveView.Socket{
                 assigns: %{__changed__: %{greeting: true}}
               }
             } = mount(param, session, socket)
    end
  end

  describe "render/1" do
    setup ~W[c_assigns_greeting c_resp_body_greet c_resp_body_to_html]a

    test "Protocol.UndefinedError", %{assigns: %{invalid: assigns}} do
      assert_raise Protocol.UndefinedError, fn ->
        render_component(Page, assigns)
      end
    end

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert render_component(Page, assigns) =~ resp_body
    end
  end
end
