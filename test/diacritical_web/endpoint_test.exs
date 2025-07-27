defmodule DiacriticalWeb.EndpointTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.4.0"

  use DiacriticalCase.Conn, async: true

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.Endpoint

  @typedoc "Represents the context."
  @typedoc since: "0.4.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.4.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_key(context()) :: context_merge()
  defp c_key(c) when is_map(c), do: %{key: :url}

  @spec c_config_url(context()) :: context_merge()
  defp c_config_url(c) when is_map(c) do
    %{config: [url: [port: 4_003, scheme: "https"]]}
  end

  @spec c_config_url_path(context()) :: context_merge()
  defp c_config_url_path(c) when is_map(c) do
    %{config: [url: [{:path, "/"} | c[:config][:url] || []]]}
  end

  @spec c_config_url_host(context()) :: context_merge()
  defp c_config_url_host(c) when is_map(c) do
    %{config: [url: [{:host, "localhost"} | c[:config][:url] || []]]}
  end

  @spec c_uri(context()) :: context_merge()
  defp c_uri(%{config: [{key, [host: host, port: port, scheme: scheme]}]} = c)
       when is_atom(key) and is_binary(host) and is_integer(port) and
              is_binary(scheme) do
    struct =
      URI.merge(
        %URI{host: host, port: port, scheme: scheme},
        c[:request_path] || ""
      )

    %{uri: %{string: URI.to_string(struct), struct: struct}}
  end

  @spec c_path(context()) :: context_merge()
  defp c_path(%{config: [{key, [path: path]}], request_path: request_path})
       when is_atom(key) and is_binary(path) and is_binary(request_path) do
    %{path: String.replace(path, ~r/^\/$/, "") <> request_path}
  end

  @spec c_config_static_url(context()) :: context_merge()
  defp c_config_static_url(%{config: [url: url]}) when is_list(url) do
    %{config: [static_url: url]}
  end

  @spec c_hash(context()) :: context_merge()
  defp c_hash(c) when is_map(c), do: %{hash: nil}

  @spec c_topic(context()) :: context_merge()
  defp c_topic(c) when is_map(c), do: %{conf: :ok, topic: "topic"}

  @spec c_event(context()) :: context_merge()
  defp c_event(c) when is_map(c) do
    %{event: "event", msg: %{id: :rand.uniform(1_000)}}
  end

  @spec c_pid(context()) :: context_merge()
  defp c_pid(c) when is_map(c) do
    %{pid: Process.whereis(:"Elixir.Diacritical.PubSub")}
  end

  @spec c_init(context()) :: context_merge()
  defp c_init(c) when is_map(c), do: %{init: []}

  @spec c_err(context()) :: context_merge()
  defp c_err(c) when is_map(c) do
    %{err: {:error, {:already_started, Process.whereis(Endpoint)}}}
  end

  doctest Endpoint, import: true

  describe "config/1" do
    import Endpoint, only: [config: 1]

    setup ~W[c_key c_config_url c_config_url_path c_config_url_host]a

    test "success", %{config: config, key: key} do
      assert config(key) == config[key]
    end
  end

  describe "config/2" do
    import Endpoint, only: [config: 2]

    setup ~W[c_key c_config_url c_config_url_path c_config_url_host]a

    test "success", %{config: config, key: key} do
      assert config(key, []) == config[key]
    end
  end

  describe "config_change/2" do
    import Endpoint, only: [config_change: 2]

    test "success" do
      assert config_change([], []) == :ok
    end
  end

  describe "server_info/1" do
    import Endpoint, only: [server_info: 1]

    setup ~W[c_config_url c_config_url_host c_uri]a

    setup %{uri: %{struct: %URI{port: port, scheme: scheme}}} do
      %{
        ip: {0, 0, 0, 0, 0, 0, 0, 0},
        port: port,
        scheme: String.to_existing_atom(scheme)
      }
    end

    test "success", %{ip: ip, port: port, scheme: scheme} do
      assert server_info(scheme) == {:ok, {ip, port}}
    end
  end

  describe "url/0" do
    import Endpoint, only: [url: 0]

    setup ~W[c_config_url c_config_url_host c_uri]a

    test "success", %{uri: %{string: uri}} do
      assert url() == uri
    end
  end

  describe "host/0" do
    import Endpoint, only: [host: 0]

    setup [:c_key, :c_config_url_host]

    test "success", %{config: config, key: key} do
      assert host() == config[key][:host]
    end
  end

  describe "path/1" do
    import Endpoint, only: [path: 1]

    setup ~W[c_config_url_path c_request_path c_path]a

    test "success", %{path: path, request_path: request_path} do
      assert path(request_path) == path
    end
  end

  describe "script_name/0" do
    import Endpoint, only: [script_name: 0]

    test "success" do
      assert script_name() == []
    end
  end

  describe "struct_url/0" do
    import Endpoint, only: [struct_url: 0]

    setup ~W[c_config_url c_config_url_host c_uri]a

    test "success", %{uri: %{struct: uri}} do
      assert struct_url() == uri
    end
  end

  describe "static_url/0" do
    import Endpoint, only: [static_url: 0]

    setup ~W[c_config_url c_config_url_host c_config_static_url c_uri]a

    test "success", %{uri: %{string: uri}} do
      assert static_url() == uri
    end
  end

  describe "static_path/1" do
    import Endpoint, only: [static_path: 1]

    setup ~W[c_config_url_path c_config_static_url c_request_path c_path]a

    test "success", %{path: path, request_path: request_path} do
      assert static_path(request_path) == path
    end
  end

  describe "static_integrity/1" do
    import Endpoint, only: [static_integrity: 1]

    setup [:c_request_path, :c_hash]

    test "success", %{hash: hash, request_path: request_path} do
      assert static_integrity(request_path) == hash
    end
  end

  describe "static_lookup/1" do
    import Endpoint, only: [static_lookup: 1]

    setup [
      :c_config_url_path,
      :c_config_static_url,
      :c_request_path,
      :c_path,
      :c_hash
    ]

    test "success", %{hash: hash, path: path, request_path: request_path} do
      assert static_lookup(request_path) == {path, hash}
    end
  end

  describe "subscribe/1" do
    import Endpoint, only: [subscribe: 1]

    setup :c_topic

    test "success", %{conf: conf, topic: topic} do
      assert subscribe(topic) == conf
    end
  end

  describe "subscribe/2" do
    import Endpoint, only: [subscribe: 2]

    setup :c_topic

    test "success", %{conf: conf, topic: topic} do
      assert subscribe(topic, []) == conf
    end
  end

  describe "unsubscribe/1" do
    import Endpoint, only: [unsubscribe: 1]

    setup :c_topic

    test "success", %{conf: conf, topic: topic} do
      assert unsubscribe(topic) == conf
    end
  end

  describe "broadcast/3" do
    import Endpoint, only: [broadcast: 3]

    setup [:c_topic, :c_event]

    test "success", %{conf: conf, event: event, msg: msg, topic: topic} do
      assert broadcast(topic, event, msg) == conf
    end
  end

  describe "broadcast!/3" do
    import Endpoint, only: [broadcast!: 3]

    setup [:c_topic, :c_event]

    test "success", %{conf: conf, event: event, msg: msg, topic: topic} do
      assert broadcast!(topic, event, msg) == conf
    end
  end

  describe "broadcast_from/4" do
    import Endpoint, only: [broadcast_from: 4]

    setup ~W[c_pid c_topic c_event]a

    test "success", %{
      conf: conf,
      event: event,
      msg: msg,
      pid: pid,
      topic: topic
    } do
      assert broadcast_from(pid, topic, event, msg) == conf
    end
  end

  describe "broadcast_from!/4" do
    import Endpoint, only: [broadcast_from!: 4]

    setup ~W[c_pid c_topic c_event]a

    test "success", %{
      conf: conf,
      event: event,
      msg: msg,
      pid: pid,
      topic: topic
    } do
      assert broadcast_from!(pid, topic, event, msg) == conf
    end
  end

  describe "local_broadcast/3" do
    import Endpoint, only: [local_broadcast: 3]

    setup [:c_topic, :c_event]

    test "success", %{conf: conf, event: event, msg: msg, topic: topic} do
      assert local_broadcast(topic, event, msg) == conf
    end
  end

  describe "local_broadcast_from/4" do
    import Endpoint, only: [local_broadcast_from: 4]

    setup ~W[c_pid c_topic c_event]a

    test "success", %{
      conf: conf,
      event: event,
      msg: msg,
      pid: pid,
      topic: topic
    } do
      assert local_broadcast_from(pid, topic, event, msg) == conf
    end
  end

  describe "child_spec/1" do
    import Endpoint, only: [child_spec: 1]

    setup :c_init

    test "success", %{init: init} do
      assert child_spec(init) == %{
               id: Endpoint,
               start: {Endpoint, :start_link, [init]},
               type: :supervisor
             }
    end
  end

  describe "start_link/0" do
    import Endpoint, only: [start_link: 0]

    setup :c_err

    test "success", %{err: err} do
      assert start_link() == err
    end
  end

  describe "start_link/1" do
    import Endpoint, only: [start_link: 1]

    setup [:c_init, :c_err]

    test "success", %{err: err, init: init} do
      assert start_link(init) == err
    end
  end

  describe "init/1" do
    import Endpoint, only: [init: 1]

    setup :c_opt

    test "success", %{opt: opt} do
      assert init(opt) == opt
    end
  end

  describe "call/2" do
    import Endpoint, only: [call: 2]

    setup [
      :c_config_url,
      :c_config_url_host,
      :c_request_path,
      :c_uri,
      :c_conn,
      :c_conn_script_name,
      :c_opt,
      :c_status,
      :c_resp_body_greeting
    ]

    setup %{conn: %{invalid: invalid} = conn} do
      %{conn: %{conn | invalid: Map.merge(invalid, %{secret_key_base: nil})}}
    end

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> call(conn, opt) end
    end

    test "success", %{
      conn: %{valid: conn},
      opt: opt,
      resp_body: resp_body,
      status: status
    } do
      assert text_response(call(conn, opt), status) == resp_body
    end
  end

  describe "__sockets__/0" do
    import Endpoint, only: [__sockets__: 0]

    test "success" do
      assert __sockets__() == []
    end
  end

  describe "socket_dispatch/2" do
    import Endpoint, only: [socket_dispatch: 2]

    setup ~W[c_request_path c_conn c_opt]a

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> socket_dispatch(conn, opt) end
    end

    test "success", %{conn: %{valid: conn}, opt: opt} do
      assert socket_dispatch(conn, opt) == conn
    end
  end

  describe "greet/2" do
    import Endpoint, only: [greet: 2]

    setup ~W[c_request_path c_conn c_opt c_status c_resp_body_greeting]a

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> greet(conn, opt) end
    end

    test "success", %{
      conn: %{valid: conn},
      opt: opt,
      resp_body: resp_body,
      status: status
    } do
      assert text_response(greet(conn, opt), status) == resp_body
    end
  end
end
