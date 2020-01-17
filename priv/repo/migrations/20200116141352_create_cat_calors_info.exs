defmodule Cats.Repo.Migrations.CreateCatCalorsInfo do
  use Ecto.Migration

  def change do
    create table(:cat_colors_info) do
      add :color, :cat_color
      add :count, :integer
    end
  end
end
