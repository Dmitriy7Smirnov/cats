defmodule RequestCnt do
  use GenServer

  @ets_name :my_ets
  @num_of_requests_key :key
  @sub_request_message :sub_request
  @requests_per_time 60000

  def request_start() do
    [{@num_of_requests_key, num_of_requests}] =  :ets.lookup(@ets_name, @num_of_requests_key)
    :ets.insert(@ets_name, {@num_of_requests_key, num_of_requests + 1})
    num_of_requests + 1
  end

  def request_stop() do
    :erlang.send_after(@requests_per_time, GenServer.whereis(__MODULE__), @sub_request_message)
  end

  def start_link(_params) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init(stack) do
    :ets.new(@ets_name, [:set, :public, :named_table])
    :ets.insert(@ets_name, {@num_of_requests_key, 0})
    {:ok, stack}
  end

  @impl true
  def handle_info(@sub_request_message, state) do
    [{@num_of_requests_key, num_of_requests}] =  :ets.lookup(@ets_name, @num_of_requests_key)
    :ets.insert(@ets_name, {@num_of_requests_key, num_of_requests - 1})
    {:noreply, state}
  end
end
