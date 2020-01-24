defmodule Cats.MixProject do
  use Mix.Project

  def project do
    [
      app: :cats,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug],
      mod: {Cats.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:ecto_enum, "~> 1.3"},
    ]
  end
end
