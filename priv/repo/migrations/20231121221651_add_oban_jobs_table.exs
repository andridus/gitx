defmodule Swapex.Repo.Migrations.AddObanJobsTable do
  use Ecto.Migration

  def up do
    Oban.Migrations.up(prefix: "private")
  end

  def down do
    Oban.Migrations.down(prefix: "private")
  end
end
