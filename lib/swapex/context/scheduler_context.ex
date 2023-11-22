defmodule Swapex.Context.SchedulerContext do
  @moduledoc """
    Scheduler Context Module has the responsibility to call jobs.
  """
  alias Swapex.Jobs.Github.FetchRepositoryJob

  @spec to_fetch_repository(username :: String.t(), repository :: String.t()) ::
          :ok | {:error, list(String.t()) | atom()}
  def to_fetch_repository(username, repository) do
    %{username: username, repository: repository}
    |> FetchRepositoryJob.new()
    |> Oban.insert()
  end
end
