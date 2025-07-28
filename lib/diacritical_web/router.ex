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

  @typedoc "Represents the nonce."
  @typedoc since: "0.6.0"
  @type nonce() :: binary()

  @typedoc "Represents the HTTP header value."
  @typedoc since: "0.6.0"
  @type header_value() :: String.t()

  @dialyzer {:no_unused, put_nonce: 2}
  @spec put_nonce(conn(), opt()) :: conn()
  defp put_nonce(conn, _opt) when is_struct(conn, Plug.Conn) do
    18
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> then(&assign(conn, :nonce, &1))
  end

  @dialyzer {:no_unused, get_content_security_policy: 1}
  @spec get_content_security_policy(nonce()) :: header_value()
  defp get_content_security_policy(nonce) when is_binary(nonce) do
    "base-uri 'self'; connect-src 'self'; default-src 'none'; " <>
      "font-src 'self' data:; form-action 'self'; frame-ancestors 'self'; " <>
      "frame-src 'self'; img-src 'nonce-#{nonce}' 'self' data:; " <>
      "script-src 'nonce-#{nonce}' 'strict-dynamic' 'unsafe-inline' 'self'; " <>
      "style-src 'nonce-#{nonce}' 'self'; upgrade-insecure-requests"
  end

  @dialyzer {:no_unused, get_permissions_policy: 0}
  @spec get_permissions_policy() :: header_value()
  defp get_permissions_policy() do
    "accelerometer=(self), ambient-light-sensor=(self), " <>
      "attribution-reporting=(self), autoplay=(self), battery=(self), " <>
      "bluetooth=(self), camera=(self), ch-ua=(self), ch-ua-arch=(self), " <>
      "ch-ua-bitness=(self), ch-ua-full-version=(self), " <>
      "ch-ua-full-version-list=(self), ch-ua-mobile=(self), " <>
      "ch-ua-model=(self), ch-ua-platform=(self), " <>
      "ch-ua-platform-version=(self), ch-ua-wow64=(self), " <>
      "compute-pressure=(self), cross-origin-isolated=(self), " <>
      "direct-sockets=(self), display-capture=(self), " <>
      "encrypted-media=(self), execution-while-not-rendered=(self), " <>
      "execution-while-out-of-viewport=(self), fullscreen=(self), " <>
      "geolocation=(self), gyroscope=(self), hid=(self), " <>
      "identity-credentials-get=(self), idle-detection=(self), " <>
      "keyboard-map=(self), magnetometer=(self), mediasession=(self), " <>
      "microphone=(self), midi=(self), navigation-override=(self), " <>
      "otp-credentials=(self), payment=(self), picture-in-picture=(self), " <>
      "publickey-credentials-get=(self), screen-wake-lock=(self), " <>
      "serial=(self), sync-xhr=(self), storage-access=(self), usb=(self), " <>
      "web-share=(self), window-management=(self), xr-spatial-tracking=(self)"
  end

  @dialyzer {:no_unused, put_secure_headers: 2}
  @spec put_secure_headers(conn(), opt()) :: conn()
  defp put_secure_headers(%Plug.Conn{assigns: %{nonce: nonce}} = conn, _opt)
       when is_binary(nonce) do
    put_secure_browser_headers(
      conn,
      %{
        "content-security-policy" => get_content_security_policy(nonce),
        "cross-origin-embedder-policy" => "require-corp",
        "cross-origin-opener-policy" => "same-origin",
        "cross-origin-resource-policy" => "same-origin",
        "permissions-policy" => get_permissions_policy(),
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
