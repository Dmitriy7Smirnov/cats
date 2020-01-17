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
      #{:enum_type, "~> 1.0.0"},
      {:plug_cowboy, "~> 2.0"},
      #{:plug, "~> 1.3.3"},
      #{:cowboy, "~> 1.1.2"},
      {:jason, "~> 1.1"},
      {:ecto_enum, "~> 1.3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
