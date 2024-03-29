defmodule Gitx.Context.IssueContextTest do
  alias Gitx.Context.IssueContext
  alias Gitx.Core.Issue
  alias Gitx.Mock.State
  use Gitx.StructCase

  describe "IssueContext" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
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

      assert {:error, ["Not Found"]} = IssueContext.fetch_issues(username, repository)
    end
  end
end
