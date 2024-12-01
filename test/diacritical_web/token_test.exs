defmodule DiacriticalWeb.TokenTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use ExUnit.Case, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.Endpoint
  alias DiacriticalWeb.Token

  @typedoc "Represents the context."
  @typedoc since: "0.6.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.6.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_data(context()) :: context_merge()
  defp c_data(c) when is_map(c) do
    %{data: %{id: :rand.uniform(1_000)}}
  end

  doctest Token, import: true

  describe "sign/1" do
    import Token, only: [sign: 1]

    setup :c_data
    setup do: %{pref: "SFMyNTY"}

    test "success", %{data: data, pref: pref} do
      assert sign(data) =~ pref
    end
  end

  describe "verify/1" do
    import Token, only: [verify: 1]

    setup :c_data

    setup %{data: data} do
      namespace = "diacritical"

      %{
        maybe_token: %{
          invalid: ~C"",
          expired:
            Phoenix.Token.sign(
              Endpoint,
              namespace,
              data,
              signed_at: System.system_time(:second) - 604_800
            ),
          missing: nil,
          unsigned: "",
          valid: Phoenix.Token.sign(Endpoint, namespace, data)
        }
      }
    end

    test "FunctionClauseError", %{maybe_token: %{invalid: maybe_token}} do
      assert_raise FunctionClauseError, fn -> verify(maybe_token) end
    end

    test "expired", %{maybe_token: %{expired: maybe_token}} do
      assert verify(maybe_token) == {:error, :expired}
    end

    test "invalid", %{maybe_token: %{unsigned: maybe_token}} do
      assert verify(maybe_token) == {:error, :invalid}
    end

    test "missing", %{maybe_token: %{missing: maybe_token}} do
      assert verify(maybe_token) == {:error, :missing}
    end

    test "success", %{data: data, maybe_token: %{valid: maybe_token}} do
      assert verify(maybe_token) == {:ok, data}
    end
  end
end
