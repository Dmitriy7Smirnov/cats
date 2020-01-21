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

    IO.inspect limit

    result = with {:ok, attr_atom} <- Validator.attribute?(attribute),
      {:ok, order_atom} <- Validator.order?(order),
      {:ok, offset_valid} <- Validator.offset?(offset),
      {:ok, limit_valid} <- Validator.limit?(limit)
    do
      query = case order_atom do
        :desc -> from cat in "cats",
        where: cat.name == "Tihon" or cat.name == "Marfa",
        select: [:name, :color, :tail_length],
        order_by: [desc: ^attr_atom],
        limit: ^limit_valid,
        offset: ^offset_valid

        :asc -> from cat in "cats",
        where: cat.name == "Tihon" or cat.name == "Marfa",
        select: [:name, :color, :tail_length],
        order_by: [asc: ^attr_atom],
        limit: ^limit_valid,
        offset: ^offset_valid
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
      {:error, _changeset} ->
        errors_map = Enum.map(changeset.errors, &Validator.err_to_map/1)
        send_resp(conn, 200,Jason.encode!(errors_map))
      _ ->
        send_resp(conn, 201, "new cat was added")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
