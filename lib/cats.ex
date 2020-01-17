defmodule Cats.Cat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cats" do
    field :name, :string
    field :color, :string
    field :tail_length, :integer
    field :whiskers_length, :integer
  end

  def changeset(cat, params \\ %{}) do
    cat
    |> cast(params, [:name, :color, :tail_length, :whiskers_length])
    |> validate_required([:name, :color, :tail_length, :whiskers_length])
    # |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:tail_length, 18..100)
    # |> validate_inclusion(:age, 18..100)
    # |> unique_constraint(:email)
  end

end
