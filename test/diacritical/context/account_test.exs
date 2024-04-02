defmodule Diacritical.Context.AccountTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.17.0"

  use DiacriticalCase.Repo, async: true

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalSchema

  alias Diacritical.Context
  alias Diacritical.Repo

  alias Context.Account
  alias DiacriticalSchema.Account.Token

  @typedoc "Represents the context."
  @typedoc since: "0.17.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.17.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_account_loaded(context()) :: context_merge()
  defp c_account_loaded(c) when is_map(c) do
    loaded =
      DiacriticalSchema.Account
      |> DiacriticalSchema.Account.query(%{limit: 1, order_by: :random})
      |> Repo.one()

    %{account: Map.merge(c[:account] || %{}, %{loaded: loaded})}
  end

  doctest Account, import: true

  describe "get_by_email/1" do
    import Account, only: [get_by_email: 1]

    setup ~W[checkout_repo c_account c_account_loaded]a

    test "FunctionClauseError", %{account: %{invalid: %{email: email}}} do
      assert_raise FunctionClauseError, fn -> get_by_email(email) end
    end

    test "missing", %{account: %{built: %{email: email}, missing: account}} do
      assert get_by_email(email) == account
    end

    test "success", %{account: %{loaded: %{email: email} = account}} do
      assert get_by_email(email) == account
    end
  end

  describe "get_by_email_and_password/2" do
    import Account, only: [get_by_email_and_password: 2]

    setup ~W[checkout_repo c_password c_account c_account_loaded]a

    test "FunctionClauseError (&1)", %{
      account: %{invalid: %{email: email}},
      password: %{correct: password}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_email_and_password(email, password)
      end
    end

    test "FunctionClauseError (&2)", %{
      account: %{loaded: %{email: email}},
      password: %{invalid: password}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_email_and_password(email, password)
      end
    end

    test "missing", %{
      account: %{built: %{email: email}, missing: account},
      password: %{correct: password}
    } do
      assert get_by_email_and_password(email, password) == account
    end

    test "incorrect", %{
      account: %{loaded: %{email: email}, missing: account},
      password: %{incorrect: password}
    } do
      assert get_by_email_and_password(email, password) == account
    end

    test "correct", %{
      account: %{loaded: %{email: email} = account},
      password: %{correct: password}
    } do
      assert get_by_email_and_password(email, password) == account
    end
  end

  describe "get_by_token_data_and_type/2" do
    import Account, only: [get_by_token_data_and_type: 2]

    setup [:checkout_repo, :c_account]

    setup do
      type = "unknown"

      %{
        token: %{
          built: %Token{data: :crypto.strong_rand_bytes(32), type: type},
          invalid: %{data: ~C"", type: ~c"#{type}"},
          loaded:
            Token
            |> Token.query(%{limit: 1, order_by: :random})
            |> Repo.one()
        }
      }
    end

    test "FunctionClauseError (&1)", %{
      token: %{invalid: %{data: data}, loaded: %{type: type}}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_token_data_and_type(data, type)
      end
    end

    test "FunctionClauseError (&2)", %{
      token: %{invalid: %{type: type}, loaded: %{data: data}}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_token_data_and_type(data, type)
      end
    end

    test "missing", %{
      account: %{missing: account},
      token: %{
        built: %{data: data, type: type},
        loaded: %{data: data!, type: type!}
      }
    } do
      assert get_by_token_data_and_type(data, type!) == account
      assert get_by_token_data_and_type(data!, type) == account
    end

    test "present", %{token: %{loaded: %{data: data, type: type}}} do
      assert %DiacriticalSchema.Account{} =
               get_by_token_data_and_type(data, type)
    end
  end

  describe "insert_token/2" do
    import Account, only: [insert_token: 2]

    setup ~W[checkout_repo c_account c_account_loaded c_param_token]a

    test "FunctionClauseError (&1)", %{
      account: %{invalid: account},
      param: %{atom: %{type: type}}
    } do
      assert_raise FunctionClauseError, fn -> insert_token(account, type) end
    end

    test "FunctionClauseError (&2)", %{
      account: %{loaded: account},
      param: %{err: %{type: type}}
    } do
      assert_raise FunctionClauseError, fn -> insert_token(account, type) end
    end

    test "failure", %{
      account: %{built: account},
      param: %{atom: %{type: type}}
    } do
      assert {:error, %Ecto.Changeset{}} = insert_token(account, type)
    end

    test "success", %{
      account: %{loaded: account},
      param: %{atom: %{type: type}}
    } do
      assert {:ok, %Token{}} = insert_token(account, type)
    end
  end
end
