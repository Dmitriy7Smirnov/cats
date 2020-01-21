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
    case offset do
      nil -> {:ok, 0}
      maybe_int -> str_to_int(maybe_int, "offset")
    end
  end

  def limit?(limit) do
    case limit do
      "all" -> {:ok, :all}
      "ALL" -> {:ok, :all}
      nil -> {:ok, :all}
      maybe_int -> str_to_int(maybe_int, "limit")
    end
  end

  defp str_to_int(maybe_int, param_str) do
    try do
      {:ok, String.to_integer(maybe_int)}
    rescue
      ArgumentError -> {:error, %{"error" => "#{param_str} not correct"}}
    end
  end

  def err_to_map({field, {reason, params}}) do
    IO.inspect Map.new(params)
    %{"field error" => field, "reason" => reason}
  end
end
