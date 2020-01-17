defmodule Cats.Repo.Migrations.CreateCats do
  use Ecto.Migration

  def change do
    create table(:cats) do
      add :name, :string
      add :color, :cat_color
      add :tail_length, :integer
      add :whiskers_length, :integer
    end
  end
end
