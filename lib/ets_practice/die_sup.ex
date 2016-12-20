defmodule EtsPractice.DieSup do
  use Supervisor
  alias EtsPractice.Die

  def add(die_id) do
    Supervisor.start_child(__MODULE__, [die_id])
  end

  defp all_dies do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, pid, _, _}) -> pid end)
  end

  ###
  # Supervisor API
  ###
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    [
      worker(Die, [], restart: :transient)
    ]
    |> supervise(strategy: :simple_one_for_one)
  end
end
