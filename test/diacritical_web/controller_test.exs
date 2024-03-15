defmodule DiacriticalWeb.ControllerTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.Controller

  @typedoc "Represents the context."
  @typedoc since: "0.5.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.5.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_conn_format_txt(context()) :: context_merge()
  defp c_conn_format_txt(%{conn: %{valid: %Plug.Conn{} = conn} = c}) do
    %{conn: %{c | valid: Phoenix.Controller.put_format(conn, "txt")}}
  end

  @spec c_action_greet(context()) :: context_merge()
  defp c_action_greet(c) when is_map(c) do
    %{action: %{invalid: "greet", valid: :greet}}
  end

  doctest Controller
end
