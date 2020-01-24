defmodule RequestCnt do
  use GenServer

  @ets_cnt :ets_cnt
  @ets_pids :ets_pids
  @num_of_requests_key :key
  @sub_request_message :sub_request
  @requests_per_time 5000
  @timeout 1000

  def change_request_cnt(pid) do
    GenServer.call(GenServer.whereis(__MODULE__), {:change_cnt, pid}, @timeout)
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks
  @impl true
  def init(params) do
    :ets.new(@ets_cnt, [:set, :private, :named_table])
    :ets.new(@ets_pids, [:set, :private, :named_table])
    :ets.insert(@ets_cnt, {@num_of_requests_key, 0})
    {:ok, params}
  end

  @impl true
  def handle_call({:change_cnt, pid}, _from, state) do
    :ets.insert(@ets_pids, {pid, 1})
    :erlang.monitor(:process, pid)
    request_cnt = :ets.update_counter(@ets_cnt, @num_of_requests_key, 1)
    {:reply, request_cnt, state}
  end

  @impl true
  def handle_info({:DOWN, _monitor_ref, :process, pid, _info}, state) do
    case :ets.lookup(@ets_pids, pid) do
      [{pid, 1}] -> :erlang.send_after(@requests_per_time, self(), {@sub_request_message, pid})
      _ -> :ignore
    end
    {:noreply, state}
  end

  @impl true
  def handle_info({@sub_request_message, pid}, state) do
    case :ets.lookup(@ets_pids, pid) do
      [{pid, 1}] ->
        :ets.update_counter(@ets_cnt, @num_of_requests_key, -1)
        :ets.delete(@ets_pids, pid)
      _ -> :ignore
    end
    {:noreply, state}
  end
end
