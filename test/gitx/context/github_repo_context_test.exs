defmodule Gitx.Context.GithubRepoContextTest do
  alias Gitx.Context.GithubRepoContext
  alias Gitx.Mock.State
  use Gitx.StructCase, async: false

  alias Gitx.Core.{Contributor, GithubRepo, Issue}

  describe "GithubRepoContext" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "fetch a repository" do
      username = "andridus"
      repository = "lx"
      # create contributors and issues on Github Api
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)

      assert {:ok,
              %GithubRepo{
                user: ^username,
                repo: ^repository,
                issues: [
                  %Issue{},
                  %Issue{}
                ],
                contributors: [
                  %Contributor{}
                ]
              }} = GithubRepoContext.fetch_repository(username, repository)
    end

    test "fetch a not-found repository" do
      username = "andridus"
      repository = "not-found"

      assert {:error, ["Not Found"]} = GithubRepoContext.fetch_repository(username, repository)
    end
  end

  describe "GithubRepoContext with rate limit" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
      State.reset()
      State.set_rate_limit(2)
      :ok
    end

    test "fetch a repository" do
      username = "andridus"
      repository = "lx"

      assert {:error, ["API rate limit " <> _]} =
               GithubRepoContext.fetch_repository(username, repository)
    end
  end
end
