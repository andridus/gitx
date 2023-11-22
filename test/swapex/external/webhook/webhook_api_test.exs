defmodule Swapex.External.Webhook.ApiTest do
  use Swapex.StructCase, async: false
  alias Swapex.Core.GithubRepo
  alias Swapex.External.Webhook
  alias Swapex.FixturesContributor
  alias Swapex.FixturesIssue
  alias Swapex.Mock.State

  describe "Webhook.Api" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Swapex.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "push data to webhook" do
      data = %{"id" => 7, "name" => "Jack Daniels", "position" => "Assistant"}
      assert {:error, :invalid_struct} = Webhook.Api.push(data)
    end

    test "error push data to webhook" do
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      {:ok, github_struct} =
        GithubRepo.create(%{
          user: fake_user,
          repo: fake_repo,
          issues: fake_issues,
          contributors: fake_contributors
        })

      github_struct = to_stringified_map(github_struct)
      assert :ok = Webhook.Api.push(github_struct)
    end

    test "error push data to webhook by unacessible domain" do
      State.set_nxdomain()
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      {:ok, github_struct} =
        GithubRepo.create(%{
          user: fake_user,
          repo: fake_repo,
          issues: fake_issues,
          contributors: fake_contributors
        })

      github_struct = to_stringified_map(github_struct)
      assert {:error, :nxdomain} = Webhook.Api.push(github_struct)
    end

    test "error push data to webhook by example rate limit" do
      State.set_rate_limit(0)
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      {:ok, github_struct} =
        GithubRepo.create(%{
          user: fake_user,
          repo: fake_repo,
          issues: fake_issues,
          contributors: fake_contributors
        })

      github_struct = to_stringified_map(github_struct)
      assert {:error, _} = Webhook.Api.push(github_struct)
    end
  end

  defp to_stringified_map(strc) do
    strc |> Jason.encode!() |> Jason.decode!()
  end
end
