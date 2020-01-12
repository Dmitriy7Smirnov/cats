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
    conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
    attribute = conn.query_params["attribute"]
    if  not Validator.attribute?(attribute) do
      result1 = %{"error" => "attribute not correct"}
      send_resp(conn, 200, Jason.encode!(result1))
    end
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

  post "/cat" do
    conn = %{conn | resp_headers: [{"content-type", "application/json"}]}
    new_cat = conn.body_params
    changeset = Cats.Cat.changeset(%Cats.Cat{}, new_cat)
    Cats.Repo.insert(changeset)
    # Cats.Repo.insert(new_cat)
    _result1 = %{"add" => "new cat"}
    send_resp(conn, 200, Jason.encode!(new_cat))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
