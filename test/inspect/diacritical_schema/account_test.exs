defmodule Inspect.DiacriticalSchema.AccountTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.15.0"

  use ExUnit.Case, async: true

  alias DiacriticalSchema

  alias DiacriticalSchema.Account

  @typedoc "Represents the document."
  @typedoc since: "0.15.0"
  @type doc() :: Inspect.Algebra.t()

  @typedoc "Represents the document binary."
  @typedoc since: "0.15.0"
  @type doc_binary() :: binary()

  @spec doc_to_binary(doc()) :: doc_binary()
  defp doc_to_binary(doc) when is_tuple(doc) do
    doc
    |> Inspect.Algebra.format(:infinity)
    |> IO.iodata_to_binary()
  end

  describe "__impl__/1" do
    import Inspect.DiacriticalSchema.Account, only: [__impl__: 1]

    test ":for" do
      assert __impl__(:for) == Account
    end

    test ":protocol" do
      assert __impl__(:protocol) == Inspect
    end
  end

  describe "inspect/2" do
    import Inspect.DiacriticalSchema.Account, only: [inspect: 2]
    import Kernel, except: [inspect: 2]

    setup do
      %{
        opt: %{invalid: %{}, valid: %Inspect.Opts{}},
        term: %{
          invalid: [],
          valid: %Account{
            email: "jdoe@example.com",
            password: "correct horse battery staple"
          }
        }
      }
    end

    test "BadMapError", %{opt: %{valid: opt}, term: %{invalid: term}} do
      assert_raise BadMapError, fn -> inspect(term, opt) end
    end

    test "FunctionClauseError", %{opt: %{invalid: opt}, term: %{valid: term}} do
      assert_raise FunctionClauseError, fn -> inspect(term, opt) end
    end

    test "success", %{
      opt: %{valid: opt},
      term: %{valid: %{email: email, password: password} = term}
    } do
      assert doc_to_binary(inspect(term, opt)) =~ email
      refute doc_to_binary(inspect(term, opt)) =~ password
    end
  end
end
