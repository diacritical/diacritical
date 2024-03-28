defmodule Diacritical.Mailer do
  @moduledoc "Defines a `Swoosh.Mailer` mailer."
  @moduledoc since: "0.14.0"

  use Swoosh.Mailer, otp_app: :diacritical
end
