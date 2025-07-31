defmodule DiacriticalWeb.LiveView.PageTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.8.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.HTML
  alias DiacriticalWeb.LiveView

  alias HTML.Layout
  alias LiveView.Page

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
               layout: {Layout, "main"},
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

    test "FunctionClauseError (&1)", %{
      param: %{invalid: param},
      session: %{valid: session},
      socket: %{valid: socket}
    } do
      assert_raise FunctionClauseError, fn -> mount(param, session, socket) end
    end

    test "FunctionClauseError (&2)", %{
      param: %{valid: param},
      session: %{invalid: session},
      socket: %{valid: socket}
    } do
      assert_raise FunctionClauseError, fn -> mount(param, session, socket) end
    end

    test "FunctionClauseError (&3)", %{
      param: %{valid: param},
      session: %{valid: session},
      socket: %{invalid: socket}
    } do
      assert_raise FunctionClauseError, fn -> mount(param, session, socket) end
    end

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
    setup ~W[c_assigns_greeting c_resp_body_greeting c_resp_body_to_html]a

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
