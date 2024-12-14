defmodule DiacriticalWebTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use ExUnit.Case, async: true

  alias DiacriticalWeb

  doctest DiacriticalWeb, import: true

  describe "static_path/0" do
    import DiacriticalWeb, only: [static_path: 0]

    test "success" do
      assert static_path() == ~W[asset bimi.svg favicon.ico robots.txt]
    end
  end

  describe "to_tenant/1" do
    import DiacriticalWeb, only: [to_tenant: 1]

    setup do
      host = "example.com"
      %{host: %{invalid: ~c"#{host}", valid: host}}
    end

    test "FunctionClauseError", %{host: %{invalid: host}} do
      assert_raise FunctionClauseError, fn -> to_tenant(host) end
    end

    test "success", %{host: %{valid: host}} do
      assert to_tenant(host) == "com_example"
    end
  end
end
