defmodule Swapex.Context.ContributorContextTest do
  alias Swapex.Context.ContributorContext
  alias Swapex.Core.Contributor
  use Swapex.StructCase

  describe "ContributorContext" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Swapex.Mock.Endpoint)
      :ok
    end

    test "fetch contributors successfuly" do
      username = "andridus"
      repository = "lx"

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
