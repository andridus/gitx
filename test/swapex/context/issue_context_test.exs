defmodule Swapex.Context.IssueContextTest do
  alias Swapex.Context.IssueContext
  alias Swapex.Core.Issue
  alias Swapex.Mock.State
  use Swapex.StructCase

  describe "IssueContext" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Swapex.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "fetch issues successfuly" do
      username = "andridus"
      repository = "lx"
      :ok = State.set_issues(username, repository, "open", false, [1])
      :ok = State.set_issues(username, repository, "open", true, [1])

      assert {:ok,
              [
                %Issue{
                  title: _,
                  author: _,
                  labels: []
                },
                %Issue{
                  title: _,
                  author: _,
                  labels: [_, _]
                }
              ]} = IssueContext.fetch_issues(username, repository)
    end

    test "fetch issues with error" do
      username = "andridus"
      repository = "not-found"

      assert {:error, ["Validation Failed"]} = IssueContext.fetch_issues(username, repository)
    end
  end
end
