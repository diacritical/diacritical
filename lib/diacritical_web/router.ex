defmodule DiacriticalWeb.Router do
  @moduledoc "Defines a `Phoenix.Router` router."
  @moduledoc since: "0.5.0"

  use Phoenix.Router, helpers: false

  import Phoenix.LiveView.Router

  alias Diacritical
  alias DiacriticalWeb

  alias Diacritical.Context
  alias Diacritical.Telemetry
  alias DiacriticalWeb.Controller
  alias DiacriticalWeb.HTML
  alias DiacriticalWeb.LiveView

  alias Context.Account
  alias Context.Option

  @typedoc "Represents the connection."
  @typedoc since: "0.6.0"
  @type conn() :: DiacriticalWeb.conn()

  @typedoc "Represents the connection option."
  @typedoc since: "0.6.0"
  @type opt() :: DiacriticalWeb.opt()

  @typedoc "Represents the cookie or session key."
  @typedoc since: "0.18.0"
  @type key() :: String.t()

  @typedoc "Represents the cookie or session value."
  @typedoc since: "0.18.0"
  @type value() :: term()

  @config Phoenix.Endpoint.Supervisor.config(
            :diacritical,
            :"Elixir.DiacriticalWeb.Endpoint"
          )

  @dialyzer {:no_unused, put_nonce: 2}
  @spec put_nonce(conn(), opt()) :: conn()
  defp put_nonce(conn, _opt) when is_struct(conn, Plug.Conn) do
    18
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> then(&assign(conn, :nonce, &1))
  end

  @dialyzer {:no_unused, put_secure_headers: 2}
  @spec put_secure_headers(conn(), opt()) :: conn()
  defp put_secure_headers(%Plug.Conn{assigns: %{nonce: nonce}} = conn, _opt)
       when is_binary(nonce) do
    cross_origin_embedder_policy =
      if @config[:code_reloader] do
        "unsafe-none"
      else
        "require-corp"
      end

    put_secure_browser_headers(
      conn,
      %{
        "content-security-policy" =>
          "base-uri 'self'; " <>
            "connect-src 'self' wss://#{conn.host}:#{conn.port}; " <>
            "default-src 'none'; " <>
            "font-src 'self'; " <>
            "form-action 'self'; " <>
            "frame-ancestors 'self'; " <>
            "frame-src 'self'; " <>
            "img-src 'self' 'nonce-#{nonce}' data:; " <>
            "script-src 'self' 'nonce-#{nonce}'; " <>
            "style-src 'self' 'nonce-#{nonce}'; " <>
            "upgrade-insecure-requests",
        "cross-origin-embedder-policy" => cross_origin_embedder_policy,
        "cross-origin-opener-policy" => "same-origin",
        "cross-origin-resource-policy" => "same-origin",
        "permissions-policy" =>
          "accelerometer=(self), ambient-light-sensor=(self), " <>
            "attribution-reporting=(self), autoplay=(self), battery=(self), " <>
            "bluetooth=(self), camera=(self), ch-ua=(self), " <>
            "ch-ua-arch=(self), ch-ua-bitness=(self), " <>
            "ch-ua-full-version=(self), ch-ua-full-version-list=(self), " <>
            "ch-ua-mobile=(self), ch-ua-model=(self), " <>
            "ch-ua-platform=(self), ch-ua-platform-version=(self), " <>
            "ch-ua-wow64=(self), compute-pressure=(self), " <>
            "cross-origin-isolated=(self), direct-sockets=(self), " <>
            "display-capture=(self), encrypted-media=(self), " <>
            "execution-while-not-rendered=(self), " <>
            "execution-while-out-of-viewport=(self), fullscreen=(self), " <>
            "geolocation=(self), gyroscope=(self), hid=(self), " <>
            "identity-credentials-get=(self), idle-detection=(self), " <>
            "keyboard-map=(self), magnetometer=(self), microphone=(self), " <>
            "midi=(self), navigation-override=(self), payment=(self), " <>
            "picture-in-picture=(self), publickey-credentials-get=(self), " <>
            "screen-wake-lock=(self), serial=(self), sync-xhr=(self), " <>
            "usb=(self), web-share=(self), window-management=(self), " <>
            "xr-spatial-tracking=(self)",
        "referrer-policy" => "no-referrer"
      }
    )
  end

  @dialyzer {:no_unused, put_tenant: 2}
  @spec put_tenant(conn(), opt()) :: conn()
  defp put_tenant(%Plug.Conn{host: host} = conn, _opt) when is_binary(host) do
    host
    |> DiacriticalWeb.to_tenant()
    |> then(&assign(conn, :tenant, &1))
  end

  @dialyzer {:no_unused, get_signed_cookie: 2}
  @spec get_signed_cookie(conn(), key()) :: value()
  defp get_signed_cookie(conn, key)
       when is_struct(conn, Plug.Conn) and is_binary(key) do
    conn
    |> fetch_cookies(signed: key)
    |> get_in([Access.key(:cookies), key])
  end

  @dialyzer {:no_unused, put_account: 2}
  @spec put_account(conn(), opt()) :: conn()
  defp put_account(conn, _opt) when is_struct(conn, Plug.Conn) do
    {token, conn} =
      cond do
        token = get_session(conn, "token") ->
          {token, conn}

        cookie = get_signed_cookie(conn, "__Host-token") ->
          {cookie, put_session(conn, "token", cookie)}

        true ->
          {nil, conn}
      end

    account = token && Account.get_by_token_data_and_type(token, "session")
    assign(conn, :account, account)
  end

  @dialyzer {:no_unused, put_option: 2}
  @spec put_option(conn(), opt()) :: conn()
  defp put_option(conn, _opt) when is_struct(conn, Plug.Conn) do
    Option.all()
    |> Map.new(&{&1.key, &1.value})
    |> then(&assign(conn, :option, &1))
  end

  pipeline :plaintext do
    plug :accepts, ["txt", "text"]
  end

  pipeline :browser do
    plug :accepts, ["html", "htm"]
    plug :fetch_session
    plug :put_root_layout, {HTML.Layout, :root}
    plug :protect_from_forgery
    plug :put_nonce
    plug :put_secure_headers
    plug :put_tenant
    plug :put_account
    plug :put_option
  end

  scope "/" do
    pipe_through :plaintext

    get "/hello", Controller.Page, :greet
  end

  if Application.compile_env(:diacritical, :env)[:dev] do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/" do
    pipe_through :browser

    live "/", LiveView.Page
  end
end
