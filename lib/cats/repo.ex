defmodule Cats.Repo do
  use Ecto.Repo,
    otp_app: :cats,
    adapter: Ecto.Adapters.Postgres
end
