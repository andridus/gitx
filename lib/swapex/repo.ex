defmodule Swapex.Repo do
  use Ecto.Repo, otp_app: :swapex, adapter: Ecto.Adapters.SQLite3
end
