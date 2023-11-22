defmodule Swapex.Context.WebhookContext do
  @moduledoc """
    Webhook Context Module has the responsibility to call jobs.
  """
  alias Swapex.Core.GithubRepo
  alias Swapex.Jobs.Webhook.PushJob

  @spec to_push(github_repo :: GithubRepo.t()) ::
          :ok | {:error, list(String.t()) | atom()}
  def to_push(github_repo) do
    tomorow = DateTime.utc_now() |> DateTime.add(1, :day)

    github_repo
    |> Map.from_struct()
    |> PushJob.new(scheduled_at: tomorow)
    |> Oban.insert()
  end
end
