defmodule Gitx.External.Github.ApiTest do
  use Gitx.StructCase, async: false

  alias DialyxirVendored.Formatter.Github
  alias Gitx.External.Github
  alias Gitx.Mock.State

  describe "Github.Api" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "get repository successful" do
      username = "andridus"
      repository = "lx"
      response = Github.Api.get_repository(username, repository)

      assert %Github.Response{
               data: %{
                 "name" => ^repository
               },
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response
    end

    test "error when get repository that not found" do
      username = "andridus"
      # previously defined on mock
      repository = "not-found"
      response = Github.Api.get_repository(username, repository)

      assert %Github.Response{
               data: %{
                 "message" => "Not Found",
                 "documentation_url" => _
               },
               status: 404,
               status_message: :not_found,
               errors: ["Not Found"],
               valid?: false
             } = response
    end

    test "error when get user and repository that not found" do
      username = "not-exists"
      # previously defined on mock
      repository = "not-found"
      response = Github.Api.get_repository(username, repository)

      assert %Github.Response{
               data: %{
                 "message" => "Not Found",
                 "documentation_url" => _
               },
               status: 404,
               status_message: :not_found,
               errors: ["Not Found"],
               valid?: false
             } = response
    end

    test "search repository issues successful" do
      username = "andridus"
      repository = "lx"
      :ok = State.set_issues(username, repository, "open", false, 1..3)
      response = Github.Api.search_repository_issues(username, repository)

      assert %Github.Response{
               data: %{
                 "incomplete_results" => false,
                 "total_count" => 3,
                 "items" => [
                   %{"number" => 1},
                   %{"number" => 2},
                   %{"number" => 3}
                 ]
               },
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response
    end

    test "error when search repository issues that not found" do
      username = "andridus"
      repository = "not-found"
      response = Github.Api.search_repository_issues(username, repository)

      assert %Github.Response{
               data: %{
                 "message" => "Validation Failed",
                 "documentation_url" => _,
                 "errors" => _
               },
               status: 200,
               status_message: :success,
               errors: ["Validation Failed"],
               valid?: false
             } = response
    end

    test "get repository issues successful" do
      username = "andridus"
      repository = "lx"
      :ok = State.set_issues(username, repository, "open", false, 1..3)
      response = Github.Api.get_repository_issues(username, repository)

      assert %Github.Response{
               data: [
                 %{"number" => 1},
                 %{"number" => 2},
                 %{"number" => 3}
               ],
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response
    end

    test "error when get repository issues that not found" do
      username = "andridus"
      repository = "not-found"
      response = Github.Api.get_repository_issues(username, repository)

      assert %Github.Response{
               data: %{
                 "message" => "Not Found",
                 "documentation_url" => _
               },
               status: 404,
               status_message: :not_found,
               errors: ["Not Found"],
               valid?: false
             } = response
    end

    test "get all repository issues successful" do
      username = "andridus"
      repository = "lx"
      :ok = State.set_issues(username, repository, "open", false, 1..210)
      response = Github.Api.get_all_repository_issues(username, repository)

      assert %Github.Response{
               data: data,
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response

      assert 210 = Enum.count(data)
    end

    test "get repository contributors successful" do
      username = "andridus"
      repository = "lx"
      State.set_contributors(username, repository, [1])
      response = Github.Api.get_repository_contributors(username, repository)

      assert %Github.Response{
               data: [
                 %{"login" => ^username}
               ],
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response
    end

    test "get repository contributors successful per page and page" do
      username = "andridus"
      repository = "lx"
      State.set_contributors(username, repository, 1..2)

      response =
        Github.Api.get_repository_contributors(username, repository, per_page: 1, page: 3)

      assert %Github.Response{
               data: [],
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response

      response =
        Github.Api.get_repository_contributors(username, repository, per_page: 1, page: 2)

      assert %Github.Response{
               data: [
                 %{"login" => _}
               ],
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response

      response =
        Github.Api.get_repository_contributors(username, repository, per_page: 1, page: 1)

      assert %Github.Response{
               data: [
                 %{"login" => ^username}
               ],
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response
    end

    test "error when get repository contributors that not found" do
      username = "andridus"
      repository = "not-found"
      response = Github.Api.get_repository_contributors(username, repository)

      assert %Github.Response{
               data: %{
                 "message" => "Not Found",
                 "documentation_url" => _
               },
               status: 404,
               status_message: :not_found,
               errors: ["Not Found"],
               valid?: false
             } = response
    end

    test "get all repository contributors successful" do
      username = "andridus"
      repository = "lx"
      :ok = State.set_contributors(username, repository, 1..210)
      response = Github.Api.get_all_repository_contributors(username, repository)

      assert %Github.Response{
               data: data,
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = response

      assert 210 = Enum.count(data)
    end
  end
end
