defmodule Cats.Repo.Migrations.CreateCatsStats do
  use Ecto.Migration

  def change do
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
