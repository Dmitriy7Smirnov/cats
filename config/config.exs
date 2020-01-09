import Config

config :cats, Cats.Repo,
  database: "cats_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :cats, ecto_repos: [Cats.Repo]
config :logger, level: :info
config :cats, web_port: 7700
