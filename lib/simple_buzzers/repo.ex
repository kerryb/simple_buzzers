defmodule SimpleBuzzers.Repo do
  use Ecto.Repo,
    otp_app: :simple_buzzers,
    adapter: Ecto.Adapters.Postgres
end
