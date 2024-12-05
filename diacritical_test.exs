ExUnit.start()

defmodule DiacriticalTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.1.0"

  use ExUnit.Case, async: true

  alias Diacritical

  doctest Diacritical, import: true

  describe "greet/0" do
    import Diacritical, only: [greet: 0]

    test "success" do
      assert greet() == "Hello, world!"
    end
  end
end
