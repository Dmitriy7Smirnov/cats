defmodule CatsTest do
  use ExUnit.Case
  doctest Cats

  test "greets the world" do
    assert Cats.hello() == :world
  end
end
