defmodule Cat.Colors.Info do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cat_colors_info" do
    field :color, CatColorEnum
    field :count, :integer
  end

  def changeset(cat_colors_info, params \\ %{}) do
    cat_colors_info
    |> cast(params, [:color, :count])
    |> validate_required([:color, :count])
    # |> validate_format(:email, ~r/@/)
    # |> validate_inclusion(:tail_length, 18..100)
    # |> validate_inclusion(:age, 18..100)
    # |> unique_constraint(:email)
  end

end
