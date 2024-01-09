defmodule Gitx.Context.SchedulerContext do
  @moduledoc """
    Scheduler Context Module has the responsibility to call jobs.
  """
  alias Gitx.Jobs.Github.FetchRepositoryJob
  alias Gitx.Validate

  @spec to_fetch_repository(params :: map()) ::
          :ok | {:error, list(String.t()) | atom()}
  def to_fetch_repository(params) do
    with {:ok, _} <- Validate.is_required?(params, "username"),
         {:ok, _} <- Validate.is_required?(params, "repository"),
         {:ok, %{"username" => username}} <-
           Validate.is_valid_non_empty_string(params, "username"),
         {:ok, %{"repository" => repository}} <-
           Validate.is_valid_non_empty_string(params, "repository") do
      %{username: username, repository: repository}
      |> FetchRepositoryJob.new()
      |> Oban.insert()
    else
      {:error, field, msg} -> {:error, "`#{field}` #{msg}"}
    end
  end
end
