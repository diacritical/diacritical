defmodule Diacritical.Repo do
  @moduledoc "Defines an `Ecto.Repo` repository."
  @moduledoc since: "0.11.0"

  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, otp_app: :diacritical
end
