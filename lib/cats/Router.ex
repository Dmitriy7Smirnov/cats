defmodule Router do
  use Plug.Router
  require Ecto.Query

  # Imports only from/2 of Ecto.Query
  import Ecto.Query, only: [from: 2]

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Jason
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/ping" do
    send_resp(conn, 200, "Cats Service. Version 0.1")
  end

  get "/cats" do
    attribute = conn.query_params["attribute"]
    attr_atom = String.to_atom(attribute)
    order = conn.query_params["order"]
    order_atom = String.to_atom(order)
    _offset = conn.query_params["offset"]
    _limit = conn.query_params["limit"]
    IO.inspect attribute
    # query = Cats.Cat |> Ecto.Query.where(name: "Tihon")
    query = case order_atom do
      :desc -> from cat in "cats",
      where: cat.name == "Tihon" or cat.name == "Marfa",
      select: [:name, :color, :tail_length],
      order_by: [desc: ^attr_atom]

      :asc -> from cat in "cats",
      where: cat.name == "Tihon" or cat.name == "Marfa",
      select: [:name, :color, :tail_length],
      order_by: [asc: ^attr_atom]
    end
    result = Cats.Repo.all(query)
    IO.inspect Jason.encode!(result)
    send_resp(conn, 200, Jason.encode!(result))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
