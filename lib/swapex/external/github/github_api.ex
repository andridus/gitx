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
end
