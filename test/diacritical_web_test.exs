defmodule DiacriticalWebTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use ExUnit.Case, async: true

  alias DiacriticalWeb

  doctest DiacriticalWeb, import: true

  describe "get_static_path/0" do
    import DiacriticalWeb, only: [get_static_path: 0]

    test "success" do
      assert get_static_path() == ~W[asset bimi.svg favicon.ico robots.txt]
    end
  end
end
