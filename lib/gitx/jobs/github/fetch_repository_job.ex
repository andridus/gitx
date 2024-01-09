defmodule Gitx.Jobs.Github.FetchRepositoryJob do
  @moduledoc """
    Gihub Job to fetch repository from Github Api
  """
  use Oban.Worker,
    queue: :github,
    max_attempts: 3,
    unique: [period: 86_400, states: [:available, :executing]]

  alias Gitx.Context.{GithubRepoContext, WebhookContext}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"username" => username, "repository" => repository}}) do
    GithubRepoContext.fetch_repository(username, repository)
    |> case do
      {:ok, github_repo} -> WebhookContext.to_push(github_repo)
      error -> error
    end
  end
end
