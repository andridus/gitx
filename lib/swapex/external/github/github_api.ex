defmodule Swapex.External.Github.Api do
  @moduledoc """
    Github Api to make requests
  """
  alias DialyxirVendored.Formatter.Github
  use Swapex.External.Api, endpoint: "https://api.github.com"
  alias Swapex.External.Github

  @doc """
    Get repository
    params
      username: string
      repository: string
  """
  @spec get_repository(username :: String.t(), repository :: String.t()) :: Github.Response.t()
  def get_repository(username, repository) do
    get("/repos/#{username}/#{repository}")
    |> Github.Response.from_httpoison()
  end

  @doc """
    Search issues
    params
      username: string
      repository: string
      state: open | closed
  """
  @spec search_repository_issues(
          username :: String.t(),
          repository :: String.t(),
          state :: String.t()
        ) ::
          Github.Response.t()
  def search_repository_issues(username, repository, state \\ "open") do
    get("/search/issues?q=repo:#{username}/#{repository}+type:issue+state:#{state}&per_page=100")
    |> Github.Response.from_httpoison()
  end

  @doc """
    get issues
    params
      username: string
      repository: string
      opts:
        per_page: integer (30),
        page: integer (1)
  """
  @spec get_repository_issues(
          username :: String.t(),
          repository :: String.t(),
          [
            {:per_page, integer()} | {:page, integer()}
          ]
        ) ::
          Github.Response.t()
  def get_repository_issues(username, repository, opts \\ []) do
    per_page = opts[:per_page] || 30
    page = opts[:page] || 1

    get("/repos/#{username}/#{repository}/issues?per_page=#{per_page}&page=#{page}")
    |> Github.Response.from_httpoison()
  end

  @doc """
    get all issues
    params
      username: string
      repository: string
      opts:
        per_page: integer (30),
        page: integer (1)
  """
  @spec get_all_repository_issues(username :: String.t(), repository :: String.t()) ::
          Github.Response.t()
  def get_all_repository_issues(username, repository) do
    per_page = 100

    do_get_all_repository_issues(username, repository, per_page, 1)
    |> Github.Response.aggregate_response()
  end

  ### ----- Private functions for all issues
  @spec do_get_all_repository_issues(
          username :: String.t(),
          repository :: String.t(),
          per_page :: integer(),
          page :: integer()
        ) :: list(Github.Response.t())
  defp do_get_all_repository_issues(username, repository, per_page, page) do
    response = get_repository_issues(username, repository, per_page: per_page, page: page)

    case response do
      %Github.Response{data: [], valid?: true} ->
        [response]

      %Github.Response{data: _data, valid?: true} ->
        [response | do_get_all_repository_issues(username, repository, per_page, page + 1)]

      %Github.Response{valid?: false} ->
        [response]
    end
  end

  ### -----

  @doc """
    get contributors
    params
      username: string
      repository: string
      opts:
        per_page: integer (30),
        page: integer (1)
  """
  @spec get_repository_contributors(username :: String.t(), repository :: String.t(), [
          {:per_page, integer()} | {:page, integer()}
        ]) ::
          Github.Response.t()
  def get_repository_contributors(username, repository, opts \\ []) do
    per_page = opts[:per_page] || 30
    page = opts[:page] || 1

    get("/repos/#{username}/#{repository}/contributors?per_page=#{per_page}&page=#{page}")
    |> Github.Response.from_httpoison()
  end

  @doc """
    get all contributors
    params
      username: string
      repository: string
      opts:
        per_page: integer (30),
        page: integer (1)
  """
  @spec get_all_repository_contributors(username :: String.t(), repository :: String.t()) ::
          Github.Response.t()
  def get_all_repository_contributors(username, repository) do
    per_page = 100

    do_get_all_repository_contributors(username, repository, per_page, 1)
    |> Github.Response.aggregate_response()
  end

  ### ----- Private functions for all issues
  @spec do_get_all_repository_contributors(
          username :: String.t(),
          repository :: String.t(),
          per_page :: integer(),
          page :: integer()
        ) :: list(Github.Response.t())
  defp do_get_all_repository_contributors(username, repository, per_page, page) do
    response = get_repository_contributors(username, repository, per_page: per_page, page: page)

    case response.data do
      [] ->
        [response]

      _data ->
        [response | do_get_all_repository_contributors(username, repository, per_page, page + 1)]
    end
  end

  ### ----
end
