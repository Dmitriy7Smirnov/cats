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
    send_resp(conn, 200, "Cats Service. Version 0.1")
  end

  get "/cats" do
    attribute = conn.query_params["attribute"]
    order = conn.query_params["order"]
    offset = conn.query_params["offset"]
    limit = conn.query_params["limit"]

    result = with {:ok, attr_atom} <- Validator.attribute?(attribute),
      {:ok, order_atom} <- Validator.order?(order),
      {:ok, _offset_atom} <- Validator.offset?(offset),
      {:ok, _limit_atom} <- Validator.limit?(limit)
    do
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

    case result do
      {:error, reason} -> send_resp(conn, 200, Jason.encode!(reason))
      _ -> result
    end
  end

  post "/cat" do
    new_cat = conn.body_params
    changeset = Cats.Cat.changeset(%Cats.Cat{}, new_cat)
    case Cats.Repo.insert(changeset) do
      {:error, changeset} ->
        put_resp_content_type(conn, "text/plain")
        res = :io_lib.format("~p",[changeset.errors])
        send_resp(conn, 200,:lists.flatten(res))
      _ ->
        send_resp(conn, 201, "new cat was added")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
