defmodule Gitx.Context.ContributorContext do
  @moduledoc """
    Contributor Context module that has the responsibility to manage issues for repository.
  """
  alias Gitx.Core.Contributor
  alias Gitx.External.Github

  @doc """
    Fetch contributors
  """
  @spec fetch_contributors(username :: String.t(), repository :: String.t()) ::
          {:ok, [Issue.t()]} | {:error, [String.t()]}
  def fetch_contributors(username, repository) do
    case Github.Api.get_repository_contributors(username, repository) do
      %Github.Response{valid?: true, data: data} ->
        contributors =
          for contributor <- data do
            Contributor.create(%{
              name: contributor["login"],
              user: contributor["login"],
              qtd_commits: contributor["contributions"]
            })
          end

        all_ok? = contributors |> Enum.all?(&(elem(&1, 0) == :ok))

        if all_ok? do
          {:ok, Enum.map(contributors, &elem(&1, 1))}
        else
          {:error, "There are contributors with error"}
        end

      %Github.Response{valid?: false, errors: errors} ->
        {:error, errors}
    end
  end
end
