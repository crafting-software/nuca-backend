defmodule NucaBackend.Repo do
  use Ecto.Repo,
    otp_app: :nuca_backend,
    adapter: Ecto.Adapters.Postgres
end
