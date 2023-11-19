defmodule Swapex.External.ApiTest do
  # alias Swapex.External.Api
  use Swapex.StructCase

  # describe "Api" do
  #   test "get swap website from httpoison" do
  #     assert {:ok, %HTTPoison.Response{status_code: 200}} =
  #              Api.httpoison_get("https://swap.financial")
  #   end

  #   test "get an inexistent swap domain website from httpoison" do
  #     assert {:error, %HTTPoison.Error{reason: :nxdomain}} =
  #              Api.httpoison_get("https://swap-inexistent.financial")
  #   end

  #   test "get a Github user from httpoison" do
  #     assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
  #              Api.httpoison_get("https://api.github.com/users/andridus")

  #     assert {:ok, data} = Jason.decode(body)
  #     assert %{"login" => "andridus"} = data
  #   end

  #   test "get a Github repo from httpoison" do
  #     assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
  #              Api.httpoison_get("https://api.github.com/repos/andridus/lx")

  #     assert {:ok, data} = Jason.decode(body)
  #     assert %{"name" => "lx"} = data
  #   end
  # end
end
