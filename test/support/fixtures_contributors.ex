defmodule Gitx.FixturesContributor do
  @moduledoc false

  alias Gitx.Core.Contributor
  alias Gitx.Fixtures

  @spec list(Range.t()) :: [Contributor.t()]
  def list(range \\ 2..6) do
    Enum.map(range, fn _ -> one() end)
  end

  @spec one() :: Contributor.t()
  def one do
    fake_name = Fixtures.valid_name()
    fake_username = Fixtures.valid_username()
    qtd_commits = Fixtures.valid_integer_non_neg()

    {:ok, contributor} =
      Contributor.create(%{
        user: fake_username,
        name: fake_name,
        qtd_commits: qtd_commits
      })

    contributor
  end
end
