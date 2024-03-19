defmodule DiacriticalWeb.Router do
  @moduledoc "Defines a `Phoenix.Router` router."
  @moduledoc since: "0.5.0"

  use Phoenix.Router, helpers: false

  alias DiacriticalWeb

  alias DiacriticalWeb.Controller
  alias DiacriticalWeb.HTML

  @typedoc "Represents the connection."
  @typedoc since: "0.6.0"
  @type conn() :: DiacriticalWeb.conn()

  @typedoc "Represents the connection option."
  @typedoc since: "0.6.0"
  @type opt() :: DiacriticalWeb.opt()

  @config Phoenix.Endpoint.Supervisor.config(
            :diacritical,
            :"Elixir.DiacriticalWeb.Endpoint"
          )

  @dialyzer {:no_unused, put_nonce: 2}
  @spec put_nonce(conn(), opt()) :: conn()
  defp put_nonce(%Plug.Conn{} = conn, _opt) do
    18
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> then(&assign(conn, :nonce, &1))
  end

  @dialyzer {:no_unused, put_secure_headers: 2}
  @spec put_secure_headers(conn(), opt()) :: conn()
  defp put_secure_headers(%Plug.Conn{assigns: %{nonce: nonce}} = conn, _opt) do
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
            "default-src 'self'; " <>
            "form-action 'self'; " <>
            "frame-ancestors 'self'; " <>
            "img-src 'self' 'nonce-#{nonce}' data:; " <>
            "object-src 'none'; " <>
            "script-src 'self' 'nonce-#{nonce}'; " <>
            "style-src 'self' 'nonce-#{nonce}'; " <>
            "upgrade-insecure-requests",
        "cross-origin-embedder-policy" => cross_origin_embedder_policy,
        "cross-origin-opener-policy" => "same-origin",
        "cross-origin-resource-policy" => "same-origin",
        "permissions-policy" =>
          "accelerometer=(), ambient-light-sensor=(), autoplay=(), " <>
            "battery=(), bluetooth=(), camera=(), ch-ua=(), ch-ua-arch=(), " <>
            "ch-ua-bitness=(), ch-ua-full-version=(), " <>
            "ch-ua-full-version-list=(), ch-ua-mobile=(), ch-ua-model=(), " <>
            "ch-ua-platform=(), ch-ua-platform-version=(), ch-ua-wow64=(), " <>
            "cross-origin-isolated=(), display-capture=(), " <>
            "encrypted-media=(), execution-while-not-rendered=(), " <>
            "execution-while-out-of-viewport=(), fullscreen=(), " <>
            "geolocation=(), gyroscope=(), hid=(), idle-detection=(), " <>
            "keyboard-map=(), magnetometer=(), microphone=(), midi=(), " <>
            "navigation-override=(), payment=(), picture-in-picture=(), " <>
            "publickey-credentials-get=(), screen-wake-lock=(), serial=(), " <>
            "sync-xhr=(), usb=(), web-share=(), window-management=(), " <>
            "xr-spatial-tracking=()",
        "referrer-policy" => "no-referrer"
      }
    )
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
  end

  scope "/" do
    pipe_through :plaintext

    get "/hello", Controller.Page, :greet
  end

  scope "/" do
    pipe_through :browser

    get "/", Controller.Page, :greet
  end
end
