defmodule Validator do

  def attribute?(attr) do
    attrs = ["id", "name", "color", "tail_length", "wiskers_length"]
    case :lists.member(attr, attrs) do
      true -> {:ok, String.to_atom(attr)}
      _ -> {:error, %{"error" => "attribute not correct"}}
    end
  end

  def order?(order) do
    order1 = case order do
      nil -> "asc"
      _ -> order
    end
    orders = ["asc", "desc"]
    case :lists.member(order1, orders) do
      true -> {:ok, String.to_atom(order1)}
      _ -> {:error, %{"error" => "order not correct"}}
    end
  end

  def offset?(offset) do
    {:ok, offset}
  end

  def limit?(limit) do
    {:ok, limit}
  end
end
