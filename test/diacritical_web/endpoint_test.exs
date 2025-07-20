defmodule DiacriticalWeb.EndpointTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.4.0"

  use ExUnit.Case, async: true

  import Plug.Test

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.Endpoint

  @typedoc "Represents the context."
  @typedoc since: "0.4.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.4.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_opt(context()) :: context_merge()
  defp c_opt(c) when is_map(c), do: %{opt: []}

  @spec c_conn(context()) :: context_merge()
  defp c_conn(c) when is_map(c) do
    %{conn: %{invalid: %{}, valid: conn(:get, "/hello")}}
  end

  @spec c_status(context()) :: context_merge()
  defp c_status(c) when is_map(c), do: %{status: 200}

  @spec c_resp_headers(context()) :: context_merge()
  defp c_resp_headers(c) when is_map(c) do
    %{
      resp_headers: [
        {"cache-control", "max-age=0, private, must-revalidate"},
        {"content-type", "text/plain; charset=utf-8"}
      ]
    }
  end

  @spec c_resp_body(context()) :: context_merge()
  defp c_resp_body(c) when is_map(c) do
    %{resp_body: "#{Diacritical.greet()}\n"}
  end

  doctest Endpoint, import: true

  describe "init/1" do
    import Endpoint, only: [init: 1]

    setup :c_opt

    test "success", %{opt: opt} do
      assert init(opt) == opt
    end
  end

  describe "call/2" do
    import Endpoint, only: [call: 2]

    setup ~W[c_conn c_opt c_resp_body c_resp_headers c_status]a

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> call(conn, opt) end
    end

    test "success", %{
      conn: %{valid: conn},
      opt: opt,
      resp_body: resp_body,
      resp_headers: resp_headers,
      status: status
    } do
      assert sent_resp(call(conn, opt)) == {status, resp_headers, resp_body}
    end
  end
end
