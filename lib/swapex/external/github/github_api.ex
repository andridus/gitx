defmodule Swapex.External.Github.Api do
  @moduledoc """
    Github Api to make requests
  """
  alias DialyxirVendored.Formatter.Github
  use Swapex.External.Api, endpoint: "https://api.github.com"
  alias Swapex.External.Github

  @spec get_repository(username :: String.t(), repository :: String.t()) :: Github.Response.t()
  def get_repository(username, repository) do
    get("/repos/#{username}/#{repository}")
    |> Github.Response.from_httpoison()
  end

  @spec get_repository_issues(
          username :: String.t(),
          repository :: String.t(),
          state :: String.t()
        ) ::
          Github.Response.t()
  def get_repository_issues(username, repository, state \\ "open") do
    get("/search/issues?q=repo:#{username}/#{repository}+type:issue+state:#{state}&per_page=100")
    |> Github.Response.from_httpoison()
  end

  @spec get_repository_contributors(username :: String.t(), repository :: String.t()) ::
          Github.Response.t()
  def get_repository_contributors(username, repository) do
    get("/repos/#{username}/#{repository}/contributors")
    |> Github.Response.from_httpoison()
  end
end
