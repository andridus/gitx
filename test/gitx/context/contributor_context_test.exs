defmodule Gitx.Context.ContributorContextTest do
  use Gitx.StructCase

  alias Gitx.Context.ContributorContext
  alias Gitx.Core.Contributor
  alias Gitx.Mock.State

  describe "ContributorContext" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "fetch contributors successfuly" do
      username = "andridus"
      repository = "lx"
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)

      assert {:ok,
              [
                %Contributor{
                  name: _,
                  user: ^username,
                  qtd_commits: 10
                }
              ]} = ContributorContext.fetch_contributors(username, repository)
    end

    test "fetch issues with error" do
      username = "andridus"
      repository = "not-found"

      assert {:error, ["Not Found"]} = ContributorContext.fetch_contributors(username, repository)
    end
  end
end
