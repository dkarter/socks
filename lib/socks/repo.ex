defmodule Socks.Repo do
  use Ecto.Repo,
    otp_app: :socks,
    adapter: Ecto.Adapters.Postgres
end
