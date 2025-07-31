defmodule DiacriticalCase.Conn do
  @moduledoc "Defines an `ExUnit.CaseTemplate` case template."
  @moduledoc since: "0.5.0"

  use DiacriticalCase

  alias DiacriticalCase

  @typedoc "Represents the context."
  @typedoc since: "0.5.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.5.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{action: _action} = c_action()

  """
  @doc since: "0.5.0"
  @spec c_action() :: context_merge()
  @spec c_action(context()) :: context_merge()
  def c_action(c \\ %{}) when is_map(c) do
    %{action: %{invalid: "greet", valid: :greet}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{conn: _conn} = c_conn()

  """
  @doc since: "0.5.0"
  @spec c_conn() :: context_merge()
  @spec c_conn(context()) :: context_merge()
  def c_conn(c \\ %{request_path: "/"}) when is_map(c) do
    %{
      conn: %{
        invalid: %{},
        valid:
          Phoenix.ConnTest.build_conn(
            :get,
            c[:uri][:string] || c[:request_path]
          )
      }
    }
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{conn: _conn} = c_conn_format(%{conn: %{valid: %Plug.Conn{}}})

  """
  @doc since: "0.5.0"
  @spec c_conn_format(context()) :: context_merge()
  def c_conn_format(%{conn: %{valid: conn} = c})
      when is_struct(conn, Plug.Conn) do
    %{conn: %{c | valid: Phoenix.Controller.put_format(conn, "txt")}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{conn: _conn} = c_conn_script_name(%{conn: %{invalid: %{}}})

  """
  @doc since: "0.5.0"
  @spec c_conn_script_name(context()) :: context_merge()
  def c_conn_script_name(%{conn: %{invalid: conn} = c}) when is_map(conn) do
    %{conn: %{c | invalid: Map.merge(conn, %{script_name: nil})}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{opt: _opt} = c_opt()

  """
  @doc since: "0.5.0"
  @spec c_opt() :: context_merge()
  @spec c_opt(context()) :: context_merge()
  def c_opt(c \\ %{}) when is_map(c), do: %{opt: []}

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{param: _param} = c_param()

  """
  @doc since: "0.5.0"
  @spec c_param() :: context_merge()
  @spec c_param(context()) :: context_merge()
  def c_param(c \\ %{}) when is_map(c), do: %{param: %{invalid: [], valid: %{}}}

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{request_path: _request_path} = c_request_path()

  """
  @doc since: "0.5.0"
  @spec c_request_path() :: context_merge()
  @spec c_request_path(context()) :: context_merge()
  def c_request_path(c \\ %{}) when is_map(c), do: %{request_path: "/hello"}

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{session: _session} = c_session()

  """
  @doc since: "0.5.0"
  @spec c_session() :: context_merge()
  @spec c_session(context()) :: context_merge()
  def c_session(c \\ %{}) when is_map(c) do
    nonce =
      18
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64()

    %{session: %{invalid: [], nonce: %{"nonce" => nonce}, valid: %{}}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{socket: _socket} = c_socket()

  """
  @doc since: "0.5.0"
  @spec c_socket() :: context_merge()
  @spec c_socket(context()) :: context_merge()
  def c_socket(c \\ %{}) when is_map(c) do
    %{socket: %{invalid: %{}, valid: %Phoenix.LiveView.Socket{}}}
  end

  @doc """
  Returns a map of fixtures to be merged into the given `context`.

  ## Example

      iex> %{status: _status} = c_status()

  """
  @doc since: "0.5.0"
  @spec c_status() :: context_merge()
  @spec c_status(context()) :: context_merge()
  def c_status(c \\ %{}) when is_map(c), do: %{status: 200}

  using do
    quote do
      import unquote(__MODULE__)
      import DiacriticalCase.View
      import Phoenix.Component, only: [assign: 3]
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest

      @endpoint DiacriticalWeb.Endpoint
    end
  end
end
