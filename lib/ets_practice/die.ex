defmodule EtsPractice.Die do
  use GenServer

  def start_link(scope) do
    GenServer.start_link(__MODULE__, nil, [name: context(scope)])
  end

  def init(nil) do
    pid = self
    send(self, :restore_state)
    :timer.send_interval(1_000, :increase_counter)

    {:ok, %{count: 0}}
  end

  def handle_info(:restore_state, state) do
    # load state from ets
    # or default values
    new_state = %{state | count: 1}
    {:noreply, new_state}
  end

  def handle_info(:increase_counter, state) do
    new_state = %{state | count: state.count + 1}
    {:noreply, new_state}
  end

  # if no message is received in _x_ number of seconds from a genserver reply with a timeout
  def handle_info(:timeout, state) do
    IO.inspect("handle_info: timeout")
    {:stop, :normal, state}
  end

  # we're a dying process
  def terminate(_reason, state) do
    # store in ETS
    {:noreply, state}
  end

  defp context(scope), do: :"context:#{scope}"
end
