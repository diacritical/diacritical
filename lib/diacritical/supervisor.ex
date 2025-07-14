defmodule Diacritical.Supervisor do
  @moduledoc "Defines a `Supervisor` supervisor."
  @moduledoc since: "0.3.0"

  use Supervisor

  @typedoc "Represents the initialization."
  @typedoc since: "0.3.0"
  @type init() :: Keyword.t()

  @typedoc "Represents the child specification."
  @typedoc since: "0.3.0"
  @type child_spec() :: Supervisor.child_spec()

  @typedoc "Represents the initialization confirmation."
  @typedoc since: "0.3.0"
  @type on_init() :: :ignore | {:ok, {Supervisor.sup_flags(), [child_spec()]}}

  @typedoc "Represents the option keyword."
  @typedoc since: "0.3.0"
  @type opt_keyword() ::
          {:name, Supervisor.name()} | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the option."
  @typedoc since: "0.3.0"
  @type opt() :: [opt_keyword()]

  @typedoc "Represents the start process confirmation."
  @typedoc since: "0.3.0"
  @type on_start() :: Supervisor.on_start()

  @doc """
  Defines the child specification for the given `init`.

  ## Example

      iex> %{init: %{valid: init}} = c_init()
      iex>
      iex> child_spec(init)
      %{
        id: Supervisor,
        start: {Supervisor, :start_link, [init]},
        type: :supervisor
      }

  """
  @doc since: "0.3.0"
  @spec child_spec(init()) :: child_spec()
  def child_spec(init) when is_list(init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init]},
      type: :supervisor
    }
  end

  @impl Supervisor
  @doc """
  Initializes a supervisor process with the given `init`.

  ## Example

      iex> %{init: %{valid: init}} = c_init()
      iex>
      iex> init(init)
      {
        :ok,
        {
          %{
            auto_shutdown: :never,
            intensity: 3,
            period: 5,
            strategy: :one_for_one
          },
          init
        }
      }

  """
  @doc since: "0.3.0"
  @spec init(init()) :: on_init()
  def init(init) when is_list(init) do
    Supervisor.init(init[:children] || [], strategy: :one_for_one)
  end

  @doc """
  Starts a supervisor with the given `init` and `opt`.

  If an `opt` list is not given, the function will give the process this module
  to use as its locally registered name.

  ## Example

      iex> start_supervisor!(%{})
      iex> %{init: %{valid: init}} = c_init()
      iex> %{err: err} = c_err()
      iex>
      iex> start_link(init)
      err

  """
  @doc since: "0.3.0"
  @spec start_link(init()) :: on_start()
  @spec start_link(init(), opt()) :: on_start()
  def start_link(init, opt \\ [name: __MODULE__])
      when is_list(init) and is_list(opt) do
    Supervisor.start_link(__MODULE__, init, opt)
  end
end
