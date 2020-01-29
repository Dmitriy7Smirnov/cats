defmodule RequestMonitor do
  use GenServer

  @table_pids :ets_pids
  @delete_pid_message :sub_request
  @set_monitor_message :set_monitor
  @time_slice 5000
  @timeout 1000

  def change_request_cnt(_pid) do
    GenServer.call(GenServer.whereis(__MODULE__), @set_monitor_message, @timeout)
  end

  def change_request_cnt1(pid) do
    GenServer.cast(GenServer.whereis(__MODULE__), {@set_monitor_message, pid})
    :ets.insert(@table_pids, {pid})
    :ets.info(@table_pids, :size)
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks
  @impl true
  def init(params) do
    :ets.new(@table_pids, [:set, :public, :named_table])
    {:ok, params}
  end

  @impl true
  def handle_call(@set_monitor_message, from, state) do
    :ets.insert(@table_pids, {from})
    :erlang.monitor(:process, from)
    pids_cnt = :ets.info(@table_pids, :size)
    {:reply, pids_cnt, state}
  end

  @impl true
  def handle_cast({@set_monitor_message, pid}, state) do
    case :erlang.is_process_alive(pid) do
      true -> :erlang.monitor(:process, pid)
      _ -> :erlang.send_after(@time_slice, self(), {@delete_pid_message, pid})
    end
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _monitor_ref, :process, pid, _info}, state) do
    :erlang.send_after(@time_slice, self(), {@delete_pid_message, pid})
    {:noreply, state}
  end

  @impl true
  def handle_info({@delete_pid_message, pid}, state) do
    :ets.delete(@table_pids, pid)
    {:noreply, state}
  end
end
