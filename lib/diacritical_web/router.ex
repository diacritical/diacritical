defmodule DiacriticalWeb.Router do
  @moduledoc "Defines a `Phoenix.Router` router."
  @moduledoc since: "0.5.0"

  use Phoenix.Router, helpers: false

  alias DiacriticalWeb

  alias DiacriticalWeb.Controller

  pipeline :plaintext do
    plug :accepts, ["txt", "text"]
  end

  scope "/" do
    pipe_through :plaintext

    get "/hello", Controller.Page, :greet
  end
end
