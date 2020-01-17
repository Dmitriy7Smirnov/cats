defmodule Router do
  use Plug.Router
  require Ecto.Query

  # Imports only from/2 of Ecto.Query
  import Ecto.Query, only: [from: 2]

  plug PlugJson
  plug PlugCnt
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Jason
  plug :dispatch

  get "/ping" do
    RequestCnt.request_stop()
    send_resp(conn, 200, "Cats Service. Version 0.1")
  end

  get "/cats" do
    attribute = conn.query_params["attribute"]
    if  not Validator.attribute?(attribute) do
      result1 = %{"error" => "attribute not correct"}
      send_resp(conn, 200, Jason.encode!(result1))
    end
    attr_atom = String.to_atom(attribute)
    IO.inspect attr_atom
    order = conn.query_params["order"]
    order1 = case order do
      nil -> "asc"
      _ -> order
    end
    if  not Validator.order?(order1) do
      result1 = %{"error" => "order not correct"}
      send_resp(conn, 200, Jason.encode!(result1))
    end
    order_atom = String.to_atom(order1)
    offset = conn.query_params["offset"]
    offset1 = case offset do
      nil -> "0"
      _ -> offset
    end
    if  not Validator.offset?(offset1) do
      result1 = %{"error" => "offset not correct"}
      send_resp(conn, 200, Jason.encode!(result1))
    end
    _limit = conn.query_params["limit"]
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
    RequestCnt.request_stop()
    send_resp(conn, 200, Jason.encode!(result))
  end

  post "/cat" do
    new_cat = conn.body_params
    changeset = Cats.Cat.changeset(%Cats.Cat{}, new_cat)
    case Cats.Repo.insert(changeset) do
      {:error, changeset} ->
        put_resp_content_type(conn, "text/plain")
        RequestCnt.request_stop()
        res = :io_lib.format("~p",[changeset.errors])
        send_resp(conn, 200,:lists.flatten(res))
      _ ->
        send_resp(conn, 200, "new cat was added")
    end
  end

  match _ do
    RequestCnt.request_stop()
    send_resp(conn, 404, "oops")
  end
end
