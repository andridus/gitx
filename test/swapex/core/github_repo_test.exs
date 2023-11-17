defmodule Swapex.Core.GithubRepoTest do
  alias Swapex.FixturesContributor
  alias Swapex.FixturesIssue
  use Swapex.StructCase
  alias Swapex.Core.GithubRepo

  describe "GithubRepo Struct" do
    test "and create a new GithubRepo Struct" do
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      assert {:ok, issue} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })

      assert ^fake_user = issue.user
      assert ^fake_repo = issue.repo
      assert ^fake_issues = issue.issues
      assert ^fake_contributors = issue.contributors
    end

    test "and create a new. Has empty issues and contributors" do
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = []
      fake_contributors = []

      assert {:ok, issue} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })

      assert ^fake_user = issue.user
      assert ^fake_repo = issue.repo
      assert ^fake_issues = issue.issues
      assert ^fake_contributors = issue.contributors
    end

    test "and create a new GithubRepo Struct with other kind of issues" do
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesContributor.list()
      fake_contributors = FixturesContributor.list()

      assert {:error, :issues, :invalid_item_list} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })
    end

    test "and create a new GithubRepo Struct with other kind of contributors" do
      fake_user = Fixtures.valid_name()
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesIssue.list()

      assert {:error, :contributors, :invalid_item_list} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })
    end

    test "and error when user is null" do
      fake_user = nil
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      assert {:error, :user, :invalid_string} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })
    end

    test "and error when user is empty string" do
      fake_user = ""
      fake_repo = Fixtures.valid_repo_name()
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      assert {:error, :user, :empty_string} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })
    end

    test "and error when repo is null" do
      fake_user = Fixtures.valid_name()
      fake_repo = nil
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      assert {:error, :repo, :invalid_slug} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })
    end

    test "and error when repo is empty string" do
      fake_user = Fixtures.valid_name()
      fake_repo = ""
      fake_issues = FixturesIssue.list()
      fake_contributors = FixturesContributor.list()

      assert {:error, :repo, :invalid_slug} =
               GithubRepo.create(%{
                 user: fake_user,
                 repo: fake_repo,
                 issues: fake_issues,
                 contributors: fake_contributors
               })
    end
  end
end
