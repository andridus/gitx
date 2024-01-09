defmodule Gitx.Context.GithubRepoContext do
  @moduledoc """
    GithubRepo Context Module has the responsibility to manage  Github respository.
  """
  alias Gitx.Context.ContributorContext
  alias Gitx.Context.IssueContext
  alias Gitx.Core.GithubRepo
  alias Gitx.External.Github

  @spec fetch_repository(username :: String.t(), repository :: String.t()) ::
          {:ok, GithubRepo.t()} | {:error, list(String.t()) | atom()}
  def fetch_repository(username, repository) do
    with %Github.Response{valid?: true, data: repository_data} <-
           Github.Api.get_repository(username, repository),
         {:ok, issues} <- IssueContext.fetch_issues(username, repository),
         {:ok, contributors} <- ContributorContext.fetch_contributors(username, repository) do
      GithubRepo.create(%{
        user: repository_data["owner"]["login"],
        repo: repository_data["name"],
        issues: issues,
        contributors: contributors
      })
    else
      %Github.Response{valid?: false, errors: errors} -> {:error, errors}
      error -> error
    end
  end
end
