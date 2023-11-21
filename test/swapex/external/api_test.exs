defmodule Swapex.External.ApiTest do
  alias Swapex.External.Api
  use Swapex.StructCase, async: false
  alias Swapex.Mock.State

  describe "Api" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Swapex.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "get swap website from httpoison" do
      assert {:ok, %HTTPoison.Response{status_code: 200}} =
               Api.httpoison_get("https://swap.financial")
    end

    test "get an inexistent swap domain website from httpoison" do
      assert {:error, %HTTPoison.Error{reason: :nxdomain}} =
               Api.httpoison_get("https://swap-inexistent.financial")
    end

    test "get a Github user from httpoison" do
      assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
               Api.httpoison_get("https://api.github.com/users/andridus")

      assert {:ok, data} = Jason.decode(body)
      assert %{"login" => "andridus"} = data
    end

    test "get a Github repo from httpoison" do
      assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
               Api.httpoison_get("https://api.github.com/repos/andridus/lx")

      assert {:ok, data} = Jason.decode(body)
      assert %{"name" => "lx"} = data
    end

    test "get an 404 from github api " do
      assert {:ok,
              %HTTPoison.Response{
                status_code: 404,
                body: body
              }} = Api.httpoison_get("https://api.github.com/repos/andridus/not-found")

      assert {:ok,
              %{
                "message" => "Not Found",
                "documentation_url" => _
              }} = Jason.decode(body)
    end

    test "get a Github issue for search repo by httpoison" do
      :ok = State.set_issues("andridus", "lx", "open", false, 1..2)

      assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
               Api.httpoison_get(
                 "https://api.github.com/search/issues?q=repo:andridus/lx+type:issue+state:open"
               )

      assert {:ok, data} = Jason.decode(body)

      assert %{
               "incomplete_results" => false,
               "total_count" => 2,
               "items" => [
                 %{"number" => 1},
                 _
               ]
             } = data
    end

    test "get a Github issue for repo by httpoison " do
      :ok = State.set_issues("andridus", "lx", "open", false, [1])

      assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
               Api.httpoison_get("https://api.github.com/repos/andridus/lx/issues")

      assert {:ok, data} = Jason.decode(body)

      assert [%{"number" => 1}] = data
    end

    test "get an 404 from github repo and issues api " do
      assert {:ok,
              %HTTPoison.Response{
                status_code: 404,
                body: body
              }} = Api.httpoison_get("https://api.github.com/repos/andridus/not-found/issues")

      assert {:ok,
              %{
                "message" => "Not Found",
                "documentation_url" => _
              }} = Jason.decode(body)
    end

    test "get a Github repo contributors by httpoison" do
      :ok = State.set_contributors("andridus", "lx", [1])

      assert {:ok, %HTTPoison.Response{body: body, status_code: 200}} =
               Api.httpoison_get("https://api.github.com/repos/andridus/lx/contributors")

      assert {:ok, data} = Jason.decode(body)
      assert [%{"login" => "andridus"}] = data
    end

    test "get an 404 from Github repo contributors api " do
      assert {:ok,
              %HTTPoison.Response{
                status_code: 404,
                body: body
              }} =
               Api.httpoison_get("https://api.github.com/repos/andridus/not-found/contributors")

      assert {:ok,
              %{
                "message" => "Not Found",
                "documentation_url" => _
              }} = Jason.decode(body)
    end
  end

  describe "Api with rate limit" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Swapex.Mock.Endpoint)
      State.reset()
      State.set_rate_limit(1)
      :ok
    end

    test "get an 403 from github" do
      assert {:ok,
              %HTTPoison.Response{
                status_code: 404,
                body: body
              }} = Api.httpoison_get("https://api.github.com/repos/andridus/not-found/issues")

      assert {:ok,
              %{
                "message" => "Not Found",
                "documentation_url" => _
              }} = Jason.decode(body)

      assert {:ok,
              %HTTPoison.Response{
                status_code: 403,
                body: body
              }} = Api.httpoison_get("https://api.github.com/repos/andridus/not-found/issues")

      assert {:ok,
              %{
                "message" => "API rate limit exceeded for" <> _,
                "documentation_url" => _
              }} = Jason.decode(body)
    end
  end
end
