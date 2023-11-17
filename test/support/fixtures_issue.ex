defmodule Swapex.FixturesIssue do
  @moduledoc false

  alias Swapex.Core.Issue
  alias Swapex.Fixtures

  @spec list(Range.t()) :: [Issue.t()]
  def list(range \\ 2..6) do
    Enum.map(range, fn _ -> one() end)
  end

  @spec one() :: Issue.t()
  def one do
    fake_title = Fixtures.valid_title()
    fake_author = Fixtures.valid_name()
    fake_labels = Fixtures.valid_list_of(:string, 2..4)

    {:ok, issue} =
      Issue.create(%{
        title: fake_title,
        author: fake_author,
        labels: fake_labels
      })

    issue
  end
end
