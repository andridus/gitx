defmodule Swapex.Context.IssueContext do
  @moduledoc """
    Issue Context module that has the responsibility to manage issues for repository.
  """
  alias Swapex.Core.Issue
  alias Swapex.External.Github

  @doc """
    Fetch issue
  """
  @spec fetch_issues(username :: String.t(), repository :: String.t()) ::
          {:ok, [Issue.t()]} | {:error, [String.t()]}
  def fetch_issues(username, repository) do
    case Github.Api.get_repository_issues(username, repository) do
      %Github.Response{valid?: true, data: data} ->
        issues =
          for issue <- data do
            Issue.create(%{
              title: issue["title"],
              author: issue["user"]["login"],
              labels: Enum.map(issue["labels"], & &1["name"])
            })
          end

        all_ok? = issues |> Enum.all?(&(elem(&1, 0) == :ok))

        if all_ok? do
          {:ok, Enum.map(issues, &elem(&1, 1))}
        else
          {:error, "There are issues with error"}
        end

      %Github.Response{valid?: false, errors: errors} ->
        {:error, errors}
    end
  end
end
