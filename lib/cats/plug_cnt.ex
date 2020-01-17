defmodule PlugCnt do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    num_of_requests = RequestCnt.request_start()
    IO.inspect num_of_requests
    case num_of_requests  do
      x when x > 2 ->
        RequestCnt.request_stop()
        conn
        |> send_resp(429, "Too Many Requests")
        |> halt()
      _ ->
        conn
    end
  end
end
