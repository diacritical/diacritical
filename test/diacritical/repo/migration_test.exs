defmodule Diacritical.Repo.MigrationTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.10.0"

  use DiacriticalCase.Repo, async: true

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  doctest Migration, import: true

  describe "migrate/0" do
    import Migration, only: [migrate: 0]

    setup :checkout_repo

    test "success" do
      assert migrate() == [{:ok, [], []}]
    end
  end

  describe "rollback/2" do
    import Migration, only: [rollback: 2]

    setup :checkout_repo

    setup do
      %{
        repo: %{invalid: "Elixir.Diacritical.Repo", valid: Repo},
        version: %{
          invalid: "9223372036854775807",
          valid: 9_223_372_036_854_775_807
        }
      }
    end

    test "FunctionClauseError (&1)", %{
      repo: %{invalid: repo},
      version: %{valid: version}
    } do
      assert_raise FunctionClauseError, fn -> rollback(repo, version) end
    end

    test "FunctionClauseError (&2)", %{
      repo: %{valid: repo},
      version: %{invalid: version}
    } do
      assert_raise FunctionClauseError, fn -> rollback(repo, version) end
    end

    test "success", %{repo: %{valid: repo}, version: %{valid: version}} do
      assert rollback(repo, version) == {:ok, [], []}
    end
  end
end
