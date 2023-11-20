defmodule Swapex.External.Github.ApiTest do
  alias DialyxirVendored.Formatter.Github
  alias Swapex.External.Github
  use Swapex.StructCase

  describe "Github.Api" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Swapex.Mock.Endpoint)
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
  end
end
