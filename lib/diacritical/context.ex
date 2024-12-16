defmodule Diacritical.Context do
  @moduledoc "Defines commonalities for `Phoenix` contexts."
  @moduledoc since: "0.16.0"

  @typedoc "Represents the confirmation."
  @typedoc since: "0.16.0"
  @type conf(changeset, schema) :: {:error, changeset} | {:ok, schema}
end
