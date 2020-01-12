defmodule Cats.Repo.Migrations.CreateCats do
  use Ecto.Migration
  use EnumType

  def change do
    # creating the enumerated type
    execute("CREATE TYPE cat_color AS ENUM ('black', 'white', 'black & white', 'red', 'red & white', 'red & black & white')")

  #   CREATE TYPE cat_color AS ENUM (
  #   'black',
  #   'white',
  #   'black & white',
  #   'red',
  #   'red & white',
  #   'red & black & white'
  #  )

  #  defenum :cat_color, :integer do
  #   value :black, 0
  #   value :white, 1
  #   value :'black & white', 2
  #   value :red, 3
  #   value :'red & white', 4
  #   value :'red & black & white', 5

  #   default :black
  # end

    create table(:cats) do
      add :name, :string
      add :color, :cat_color
      add :tail_length, :integer
      add :whiskers_length, :integer
    end

    create table(:cat_colors_info) do
      add :color, :cat_color
      add :count, :integer
    end

    create table(:cats_stat) do
      add :tail_length_mean, :float
      add :tail_length_median, :float
      add :tail_length_mode, :integer
      add :whiskers_length_mean, :float
      add :whiskers_length_median, :float
      add :whiskers_length_mode, :integer
    end
  end
end
