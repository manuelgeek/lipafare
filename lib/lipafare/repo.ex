defmodule Lipafare.Repo do
  use Ecto.Repo,
    otp_app: :lipafare,
    adapter: Ecto.Adapters.Postgres
end
