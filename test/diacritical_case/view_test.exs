defmodule DiacriticalCase.ViewTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Template, async: true

  alias Diacritical
  alias DiacriticalCase

  alias DiacriticalCase.View

  doctest View, import: true

  describe "__ex_unit__/2" do
    setup :c_context

    test ":setup", %{context: %{valid: context}} do
      assert View.__ex_unit__(:setup, context) == context
    end

    test ":setup_all", %{context: %{valid: context}} do
      assert View.__ex_unit__(:setup_all, context) == context
    end
  end

  describe "assert_element/2" do
    import View, only: [assert_element: 2]

    setup do
      %{html: "<span>#{Diacritical.greet()}</span>", selector: "span"}
    end

    test "success", %{html: html, selector: selector} do
      assert assert_element html, selector
    end
  end

  describe "c_assigns_empty/0" do
    import View, only: [c_assigns_empty: 0]

    test "success" do
      assert %{assigns: _assigns} = c_assigns_empty()
    end
  end

  describe "c_assigns_empty/1" do
    import View, only: [c_assigns_empty: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_assigns_empty(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{assigns: _assigns} = c_assigns_empty(context)
    end
  end

  describe "c_assigns_greeting/0" do
    import View, only: [c_assigns_greeting: 0]

    test "success" do
      assert %{assigns: _assigns} = c_assigns_greeting()
    end
  end

  describe "c_assigns_greeting/1" do
    import View, only: [c_assigns_greeting: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_assigns_greeting(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{assigns: _assigns} = c_assigns_greeting(context)
    end
  end

  describe "c_resp_body_dismiss/0" do
    import View, only: [c_resp_body_dismiss: 0]

    test "success" do
      assert %{resp_body: _resp_body} = c_resp_body_dismiss()
    end
  end

  describe "c_resp_body_dismiss/1" do
    import View, only: [c_resp_body_dismiss: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_resp_body_dismiss(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{resp_body: _resp_body} = c_resp_body_dismiss(context)
    end
  end

  describe "c_resp_body_greet/0" do
    import View, only: [c_resp_body_greet: 0]

    test "success" do
      assert %{resp_body: _resp_body} = c_resp_body_greet()
    end
  end

  describe "c_resp_body_greet/1" do
    import View, only: [c_resp_body_greet: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_resp_body_greet(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{resp_body: _resp_body} = c_resp_body_greet(context)
    end
  end

  describe "c_resp_body_404/0" do
    import View, only: [c_resp_body_404: 0]

    test "success" do
      assert %{resp_body: _resp_body} = c_resp_body_404()
    end
  end

  describe "c_resp_body_404/1" do
    import View, only: [c_resp_body_404: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_resp_body_404(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{resp_body: _resp_body} = c_resp_body_404(context)
    end
  end

  describe "c_resp_body_500/0" do
    import View, only: [c_resp_body_500: 0]

    test "success" do
      assert %{resp_body: _resp_body} = c_resp_body_500()
    end
  end

  describe "c_resp_body_500/1" do
    import View, only: [c_resp_body_500: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_resp_body_500(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{resp_body: _resp_body} = c_resp_body_500(context)
    end
  end

  describe "c_selector_span/0" do
    import View, only: [c_selector_span: 0]

    test "success" do
      assert %{selector: _selector} = c_selector_span()
    end
  end

  describe "c_selector_span/1" do
    import View, only: [c_selector_span: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_selector_span(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{selector: _selector} = c_selector_span(context)
    end
  end
end
