defmodule Diacritical.Context.OptionTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.23.0"

  use DiacriticalCase.Repo, async: true

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Context

  alias Context.Option

  doctest Option, import: true

  describe "all/0" do
    import Option, only: [all: 0]

    setup :checkout_repo

    test "success" do
      assert [%DiacriticalSchema.Option{} | _option] = all()
    end
  end
end
