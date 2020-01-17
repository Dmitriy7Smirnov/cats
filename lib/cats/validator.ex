defmodule Validator do

  def attribute?(attr) do
    attrs = ["id", "name", "color", "tail_length", "wiskers_length"]
    :lists.member(attr, attrs)
  end

  def order?(order) do
    orders = ["asc", "desc"]
    :lists.member(order, orders)
  end

  def offset?(_offset) do
    true
  end

end
