defmodule Swapex.Mock.Endpoint do
  @moduledoc """
    Mock of Github Endpoint for HTTPoison
  """
  use HTTPMock, behaviour: :httpoison
  alias Swapex.Mock.{GithubFunctions, SwapFunctions}

  endpoint "https://api.github.com" do
    get "/users/:username", GithubFunctions, :get_user
    get "/repos/:username/:repo", GithubFunctions, :get_repo
    get "/repos/:username/:repo/issues", GithubFunctions, :get_repo_issues
    get "/search/issues", GithubFunctions, :search_repo_issues
    get "/repos/:username/:repo/contributors", GithubFunctions, :get_repo_contributors
  end

  endpoint "https://swap.financial" do
    get "", SwapFunctions, :get_website
  end

  endpoint "https://swap-inexistent.financial" do
    get "", SwapFunctions, :throw_error_nxdomain
  end
end
