defmodule PlugCnt do
  import Plug.Conn

  @request_threshold 3

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    uniq_ref = :erlang.make_ref()
    :gproc.send({:p, :l, :incr}, {self(), :incr, uniq_ref})
    receive do
      {^uniq_ref, request_count} when request_count >= @request_threshold ->
        IO.inspect "Plug_cnt #{request_count}"
        conn
          |> send_resp(429, "Too Many Requests")
          |> halt()
      {^uniq_ref, request_count} ->
        IO.inspect "Plug_cnt #{request_count}"
        conn
      after 1000 ->
        conn
          |> send_resp(429, "Server timeout error")
          |> halt()
    end
  end
end
