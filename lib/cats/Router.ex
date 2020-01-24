defmodule Router do
  use Plug.Router
  # import Ecto.Query

  # Imports only from/2 of Ecto.Query
  import Ecto.Query, only: [from: 2]

  plug PlugCnt
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Jason
  plug :dispatch

  get "/ping" do
    conn
      |> put_resp_content_type("text/plain")
      send_resp(conn, 200, "Cats Service. Version 0.1")
  end

  get "/cats" do
    conn = put_resp_content_type(conn, "application/json")
    attribute = conn.query_params["attribute"]
    order = conn.query_params["order"]
    offset = conn.query_params["offset"]
    limit = conn.query_params["limit"]

    result1 = with {:ok, attr_atom} <- Parser.attribute(attribute),
      {:ok, order_atom} <- Parser.order(order),
      {:ok, offset_valid} <- Parser.offset(offset),
      {:ok, limit_valid} <- Parser.limit(limit)
    do
      query =  from cat in "cats",
          where: cat.name == "Tihon" or cat.name == "Marfa",
          select: [:name, :color, :tail_length],
          order_by: [{^order_atom, ^attr_atom}],
          offset: ^offset_valid

      result = case limit_valid do
        :all -> Cats.Repo.all(query)
        number -> Cats.Repo.all(Ecto.Query.limit(query, ^number))
      end
        send_resp(conn, 200, Jason.encode!(result))
    end

    case result1 do
      {:error, reason} ->
          send_resp(conn, 400, Jason.encode!(reason))
      _ -> result1
    end
  end

  post "/cat" do
    new_cat = conn.body_params
    changeset = Cats.Cat.changeset(%Cats.Cat{}, new_cat)
    case Cats.Repo.insert(changeset) do
      {:error, _changeset} ->
        errors_map = Enum.map(changeset.errors, &Parser.err_to_map/1)
        send_resp(conn, 400,Jason.encode!(errors_map))
      _ ->
        conn
          |> put_resp_content_type("text/plain")
          send_resp(conn, 201, "new cat was added")
    end
  end

  match _ do
    conn
      |> put_resp_content_type("text/plain")
      |> send_resp(404, "oops")
  end
end
