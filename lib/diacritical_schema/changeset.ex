defmodule DiacriticalSchema.Changeset do
  @moduledoc "Defines commonalities for `Ecto.Changeset` changesets."
  @moduledoc since: "0.15.0"

  alias DiacriticalSchema

  @typedoc "Represents the changeset of a specified data-type."
  @typedoc since: "0.15.0"
  @type t(data_type) :: Ecto.Changeset.t(data_type)

  @typedoc "Represents the data-type."
  @typedoc since: "0.15.0"
  @type data_type() :: nil | map() | DiacriticalSchema.t()

  @typedoc "Represents the changeset."
  @typedoc since: "0.15.0"
  @type t() :: t(data_type())

  @typedoc "Represents the change key."
  @typedoc since: "0.15.0"
  @type change_key() :: atom()

  @typedoc "Represents the format."
  @typedoc since: "0.15.0"
  @type format() :: Regex.t()

  @typedoc "Represents the data."
  @typedoc since: "0.15.0"
  @type data(changeset, schema) :: changeset | schema

  @typedoc "Represents the parameter key."
  @typedoc since: "0.15.0"
  @type key() :: atom() | String.t()

  @typedoc "Represents the parameter."
  @typedoc since: "0.15.0"
  @type param() :: :invalid | %{required(key()) => term()}

  @doc """
  Hashes the value of the `changeset` change, `key`, onto `digest_key`.

  If a change key is not given for `digest_key`, or if the value given is `nil`,
  the change is put onto (an existing atom) in the shape of `key\#{_digest}`; so
  if a value is not given for `key`, the function defaults to the change key
  `:password`, making the default `digest_key` change key `:password_digest`.

  If the given `changeset` is not valid, the function behaves as an identity
  transformation, because the underlying key derivation is (necessarily)
  expensive. Finally, if the resultant digest is put onto the new change key,
  `digest_key`, then the original change, `key`, is deleted from the
  `changeset`, and the new changeset is returned.

  ## Examples

      iex> c = c_password()
      iex> %{changeset: %{indigestible: changeset}} = c_changeset_digest(c)
      iex>
      iex> put_digest(changeset)
      changeset

      iex> c = c_password()
      iex> %{changeset: %{digestible: changeset}} = c_changeset_digest(c)
      iex>
      iex> %Ecto.Changeset{changes: %{password_digest: _digest}} =
      iex>   put_digest(changeset)

  """
  @doc since: "0.15.0"
  @spec put_digest(t()) :: t()
  @spec put_digest(t(), change_key()) :: t()
  @spec put_digest(t(), change_key(), change_key()) :: t()
  def put_digest(changeset, key \\ :password, digest_key \\ nil)

  def put_digest(%Ecto.Changeset{valid?: true} = changeset, key, nil)
      when is_atom(key) do
    put_digest(changeset, key, String.to_existing_atom("#{key}_digest"))
  end

  def put_digest(%Ecto.Changeset{valid?: true} = changeset, key, digest_key)
      when is_atom(key) and is_atom(digest_key) do
    message = Ecto.Changeset.get_change(changeset, key)

    changeset
    |> Ecto.Changeset.put_change(digest_key, Argon2.hash_pwd_salt(message))
    |> Ecto.Changeset.delete_change(key)
  end

  def put_digest(%Ecto.Changeset{} = changeset, key, digest_key)
      when is_atom(key) and is_atom(digest_key) do
    changeset
  end

  @spec regex_argon2() :: format()
  defp regex_argon2() do
    regex =
      ~S"^\$argon2(?:[di]|id)" <>
        ~S"\$v=[0-9]+\$m=[0-9]+,t=[0-9]+,p=[0-9]+" <>
        ~S"\$(?:[+/0-9A-Za-z]+)\$(?:[+/0-9A-Za-z]+)$"

    ~r/#{regex}/
  end

  @doc """
  Validates the value of a `changeset` change, `key`, as an `Argon2` digest.

  If a `key` is not given, the function defaults to the change key
  `:password_digest`.

  ## Examples

      iex> %{changeset: %{undigested: changeset}} = c_changeset_argon2(%{})
      iex>
      iex> %Ecto.Changeset{valid?: false} = validate_argon2(changeset)

      iex> %{changeset: %{digested: changeset}} = c_changeset_argon2(%{})
      iex>
      iex> %Ecto.Changeset{valid?: true} = validate_argon2(changeset)

  """
  @doc since: "0.15.0"
  @spec validate_argon2(t()) :: t()
  @spec validate_argon2(t(), change_key()) :: t()
  def validate_argon2(%Ecto.Changeset{} = changeset, key \\ :password_digest)
      when is_atom(key) do
    Ecto.Changeset.validate_format(changeset, key, regex_argon2())
  end

  @spec regex_email() :: format()
  defp regex_email() do
    ~r/^.+@.+$/i
  end

  @doc """
  Validates the value of a `changeset` change, `key`, as an email address.

  If a `key` is not given, the function defaults to the change key `:email`.

  ## Examples

      iex> %{changeset: %{unaddressed: changeset}} = c_changeset_email(%{})
      iex>
      iex> %Ecto.Changeset{valid?: false} = validate_email(changeset)

      iex> %{changeset: %{addressed: changeset}} = c_changeset_email(%{})
      iex>
      iex> %Ecto.Changeset{valid?: true} = validate_email(changeset)

  """
  @doc since: "0.15.0"
  @spec validate_email(t()) :: t()
  @spec validate_email(t(), change_key()) :: t()
  def validate_email(%Ecto.Changeset{} = changeset, key \\ :email)
      when is_atom(key) do
    changeset
    |> Ecto.Changeset.validate_format(key, regex_email())
    |> Ecto.Changeset.validate_length(key, max: 254)
  end

  @doc """
  Validates the value of a `changeset` change, `key`, as a password.

  If a `key` is not given, the function defaults to the change key `:password`.

  ## Examples

      iex> c = c_password()
      iex> %{changeset: %{short: changeset}} = c_changeset_password(c)
      iex>
      iex> %Ecto.Changeset{valid?: false} = validate_password(changeset)

      iex> c = c_password()
      iex> %{changeset: %{long: changeset}} = c_changeset_password(c)
      iex>
      iex> %Ecto.Changeset{valid?: false} = validate_password(changeset)

      iex> c = c_password()
      iex> %{changeset: %{goldilocks: changeset}} = c_changeset_password(c)
      iex>
      iex> %Ecto.Changeset{valid?: true} = validate_password(changeset)

  """
  @doc since: "0.15.0"
  @spec validate_password(t()) :: t()
  @spec validate_password(t(), change_key()) :: t()
  def validate_password(%Ecto.Changeset{} = changeset, key \\ :password)
      when is_atom(key) do
    Ecto.Changeset.validate_length(changeset, key, max: 128, min: 8)
  end

  @spec regex_slug() :: format()
  defp regex_slug(), do: ~r/^(?!^-|.*-$|.*-{2})(?:[-0-9_a-z])+$/i

  @doc """
  Validates the value of a `changeset` change, `key`, as a slug.

  If a `key` is not given, the function defaults to the change key `:slug`.

  ## Examples

      iex> %{changeset: %{unslugified: changeset}} = c_changeset_slug(%{})
      iex>
      iex> %Ecto.Changeset{valid?: false} = validate_slug(changeset)

      iex> %{changeset: %{slugified: changeset}} = c_changeset_slug(%{})
      iex>
      iex> %Ecto.Changeset{valid?: true} = validate_slug(changeset)

  """
  @doc since: "0.22.0"
  @spec validate_slug(t()) :: t()
  @spec validate_slug(t(), change_key()) :: t()
  def validate_slug(%Ecto.Changeset{} = changeset, key \\ :slug)
      when is_atom(key) do
    changeset
    |> Ecto.Changeset.validate_format(key, regex_slug())
    |> Ecto.Changeset.validate_length(key, max: 32)
  end
end
