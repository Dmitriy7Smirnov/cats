defmodule Cats.Cat do
  use Ecto.Schema

  schema "cats" do
    field :name, :string
    field :color, :string
    field :tail_length, :integer
    field :whiskers_length, :integer
  end

end
