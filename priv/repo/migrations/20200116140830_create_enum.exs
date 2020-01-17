defmodule Cats.Repo.Migrations.CreateEnum do
  use Ecto.Migration

  def change do
    # creating the enumerated type
    execute("CREATE TYPE cat_color AS ENUM ('black', 'white', 'black & white', 'red', 'red & white', 'red & black & white')")
  end
end
