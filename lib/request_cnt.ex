defmodule RequestCnt do
  use GenServer

  @ets_name :my_ets
  @num_of_requests_key :key
  @sub_request_message :sub_request
  @requests_per_time 5000
  @gproc_key :incr

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks
  @impl true
  def init(_stack) do
    :ets.new(@ets_name, [:set, :public, :named_table])
    :ets.insert(@ets_name, {@num_of_requests_key, 0})
    :gproc.reg({:p, :l, @gproc_key})
    {:ok, []}
  end

  @impl true
  def handle_info({pid, @gproc_key, uniq_ref}, state) do
    request_count = :ets.update_counter(@ets_name, @num_of_requests_key, 1)
    send(pid, {uniq_ref, request_count})
    :erlang.monitor(:process, pid)
    {:noreply, [pid | state]}
  end

  @impl true
  def handle_info({:DOWN, _monitor_ref, :process, pid, _info}, state) do
    case :lists.member(pid, state) do
      true -> :erlang.send_after(@requests_per_time, GenServer.whereis(__MODULE__), {@sub_request_message, pid})
      _ -> :ignore
    end
    {:noreply, state}
  end

  @impl true
  def handle_info({@sub_request_message, pid}, state) do
    state1 = case :lists.member(pid, state) do
      true ->
        :ets.update_counter(@ets_name, @num_of_requests_key, -1)
        :lists.delete(pid, state)
      _ -> state
    end
    {:noreply, state1}
  end
end
