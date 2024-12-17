defmodule Diacritical.Gettext do
  @moduledoc "Defines a `Gettext` backend."
  @moduledoc since: "0.19.0"

  use Gettext.Backend, otp_app: :diacritical, priv: "priv/diacritical/gettext"
end
