defmodule Diacritical.Context.AccountTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.16.0"

  use DiacriticalCase.Repo, async: true

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalSchema

  alias Diacritical.Context
  alias Diacritical.Repo

  alias Context.Account
  alias DiacriticalSchema.Account.Token

  @typedoc "Represents the context."
  @typedoc since: "0.16.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.16.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_token(context()) :: context_merge()
  defp c_token(c) when is_map(c) do
    type = "unknown"

    %{
      token: %{
        built: %Token{data: :crypto.strong_rand_bytes(32), type: type},
        invalid: %{data: ~C"", type: ~c"#{type}"}
      }
    }
  end

  @spec c_account_loaded(context()) :: context_merge()
  defp c_account_loaded(c) when is_map(c) do
    loaded =
      DiacriticalSchema.Account
      |> DiacriticalSchema.Account.query(%{limit: 1, order_by: :random})
      |> Repo.one()

    %{account: Map.merge(c[:account] || %{}, %{loaded: loaded})}
  end

  doctest Account, import: true

  describe "delete_token_by_data_and_type/2" do
    import Account, only: [delete_token_by_data_and_type: 2]

    setup ~W[checkout_repo c_token c_token_loaded]a
    setup do: %{conf: %{missing: {0, nil}, found: {1, nil}}}

    test "FunctionClauseError (&1)", %{
      token: %{invalid: %{data: data}, loaded: token}
    } do
      assert_raise FunctionClauseError, fn ->
        delete_token_by_data_and_type(data, token.type)
      end
    end

    test "FunctionClauseError (&2)", %{
      token: %{invalid: %{type: type}, loaded: token}
    } do
      assert_raise FunctionClauseError, fn ->
        delete_token_by_data_and_type(token.data, type)
      end
    end

    test "missing", %{
      conf: %{missing: conf},
      token: %{built: token, loaded: token!}
    } do
      assert delete_token_by_data_and_type(token.data, token.type) == conf
      assert delete_token_by_data_and_type(token!.data, token.type) == conf
      assert delete_token_by_data_and_type(token.data, token!.type) == conf
    end

    test "success", %{conf: %{found: conf}, token: %{loaded: token}} do
      assert delete_token_by_data_and_type(token.data, token.type) == conf
    end
  end

  describe "get_by_email/1" do
    import Account, only: [get_by_email: 1]

    setup ~W[checkout_repo c_account c_account_loaded]a

    test "FunctionClauseError", %{account: %{invalid: %{email: email}}} do
      assert_raise FunctionClauseError, fn -> get_by_email(email) end
    end

    test "missing", %{account: %{built: account, missing: account!}} do
      assert get_by_email(account.email) == account!
    end

    test "success", %{account: %{loaded: account}} do
      assert get_by_email(account.email) == account
    end
  end

  describe "get_by_email_and_password/2" do
    import Account, only: [get_by_email_and_password: 2]

    setup ~W[checkout_repo c_data_password c_account c_account_loaded]a

    test "FunctionClauseError (&1)", %{
      account: %{invalid: %{email: email}},
      password: %{correct: password}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_email_and_password(email, password)
      end
    end

    test "FunctionClauseError (&2)", %{
      account: %{loaded: account},
      password: %{invalid: password}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_email_and_password(account.email, password)
      end
    end

    test "missing", %{
      account: %{built: account, missing: account!},
      password: %{correct: password}
    } do
      assert get_by_email_and_password(account.email, password) == account!
    end

    test "incorrect", %{
      account: %{loaded: account, missing: account!},
      password: %{incorrect: password}
    } do
      assert get_by_email_and_password(account.email, password) == account!
    end

    test "correct", %{
      account: %{loaded: account},
      password: %{correct: password}
    } do
      assert get_by_email_and_password(account.email, password) == account
    end
  end

  describe "get_by_token_data_and_type/2" do
    import Account, only: [get_by_token_data_and_type: 2]

    setup ~W[checkout_repo c_token c_token_loaded c_account]a

    test "FunctionClauseError (&1)", %{
      token: %{invalid: %{data: data}, loaded: token}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_token_data_and_type(data, token.type)
      end
    end

    test "FunctionClauseError (&2)", %{
      token: %{invalid: %{type: type}, loaded: token}
    } do
      assert_raise FunctionClauseError, fn ->
        get_by_token_data_and_type(token.data, type)
      end
    end

    test "missing", %{
      account: %{missing: account},
      token: %{built: token, loaded: token!}
    } do
      assert get_by_token_data_and_type(token.data, token!.type) == account
      assert get_by_token_data_and_type(token!.data, token.type) == account
    end

    test "present", %{token: %{loaded: token}} do
      assert %DiacriticalSchema.Account{} =
               get_by_token_data_and_type(token.data, token.type)
    end
  end

  describe "insert/1" do
    import Account, only: [insert: 1]

    setup [:checkout_repo, :c_param_account]

    test "FunctionClauseError", %{param: %{invalid: param}} do
      assert_raise FunctionClauseError, fn -> insert(param) end
    end

    test "failure", %{param: %{err: param}} do
      assert {:error, %Ecto.Changeset{}} = insert(param)
    end

    test "atom", %{param: %{atom: param}} do
      assert {:ok, %DiacriticalSchema.Account{}} = insert(param)
    end

    test "string", %{param: %{string: param}} do
      assert {:ok, %DiacriticalSchema.Account{}} = insert(param)
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
