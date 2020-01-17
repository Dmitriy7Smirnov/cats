defmodule Cats.Stat do
  use Ecto.Schema
  #import Ecto.Changeset

  # schema "cats" do
  #   field :name, :string
  #   field :color, :string
  #   field :tail_length, :integer
  #   field :whiskers_length, :integer
  # end

  schema "cats_stat" do
    field :tail_length_mean, :float
    field :tail_length_median, :float
    field :tail_length_mode, :integer
    field :whiskers_length_mean, :float
    field :whiskers_length_median, :float
    field :whiskers_length_mode, :integer
  end

  # create table(:cats_stat) do
  #   add :tail_length_mean, :float
  #   add :tail_length_median, :float
  #   add :tail_length_mode, :integer
  #   add :whiskers_length_mean, :float
  #   add :whiskers_length_median, :float
  #   add :whiskers_length_mode, :integer
  # end

end
