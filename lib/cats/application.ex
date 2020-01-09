defmodule Cats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Cats app started...", [])

    web_port = Application.get_env(:cats, :web_port)

    children = [
      Cats.Repo,
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], port: web_port)
      # Starts a worker by calling: Cats.Worker.start_link(arg)
      # {Cats.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cats.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
