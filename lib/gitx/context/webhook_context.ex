defmodule Gitx.Context.WebhookContext do
  @moduledoc """
    Webhook Context Module has the responsibility to call jobs.
  """
  alias Gitx.Core.GithubRepo
  alias Gitx.Jobs.Webhook.PushJob

  @spec to_push(github_repo :: GithubRepo.t()) ::
          :ok | {:error, list(String.t()) | atom()}
  def to_push(github_repo) do
    tomorow = DateTime.utc_now() |> DateTime.add(1, delivery_atom())

    github_repo
    |> Map.from_struct()
    |> PushJob.new(scheduled_at: tomorow)
    |> Oban.insert()
  end

  defp delivery_atom do
    delivery = Application.get_env(:gitx, :delivery)

    if delivery in ["hour", "minute", "day"] do
      String.to_atom(delivery)
    else
      :day
    end
  end
end
