defmodule Gitx.Repo do
  use Ecto.Repo, otp_app: :gitx, adapter: Ecto.Adapters.Postgres
end
