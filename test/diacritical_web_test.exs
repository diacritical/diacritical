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
end
