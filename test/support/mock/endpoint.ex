defmodule Swapex.Mock.Endpoint do
  @moduledoc """
    Mock of Github Endpoint for HTTPoison
  """
  use HTTPMock, behaviour: :httpoison
  alias Swapex.Mock.{GithubFunctions, SwapFunctions}

  endpoint "https://api.github.com" do
    get "/users/:username", GithubFunctions, :get_user
    get "/repos/:username/:repo", GithubFunctions, :get_repo
  end

  endpoint "https://swap.financial" do
    get "", SwapFunctions, :get_website
  end

  endpoint "https://swap-inexistent.financial" do
    get "", SwapFunctions, :throw_error_nxdomain
  end
end
