defmodule PlugCnt do
  import Plug.Conn

  @request_threshold 3

  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    case RequestMonitor.change_request_cnt(self()) do
      x when x >= @request_threshold ->
        IO.inspect x
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(429, "Too Many Requests")
          |> halt()
      _ ->
        conn
    end
  end
end
