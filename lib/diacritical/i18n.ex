defmodule Diacritical.I18n do
  @moduledoc "Defines a `Gettext` interface."
  @moduledoc since: "0.19.0"

  use Gettext, otp_app: :diacritical, priv: "priv/diacritical/gettext"
end
