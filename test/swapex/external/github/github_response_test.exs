defmodule Swapex.External.Github.ResponseTest do
  alias Swapex.External.Github
  use Swapex.StructCase

  describe "Github.Response" do
    test "parse body" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = %HTTPoison.Response{status_code: 200, body: body}
      assert {:ok, ^json} = Github.Response.parse_body(httpoison_response.body)
    end

    test "parse body with invalid json" do
      body = "invalid_json"
      httpoison_response = %HTTPoison.Response{status_code: 200, body: body}
      assert {:error, :body, :invalid_json} = Github.Response.parse_body(httpoison_response.body)
    end

    test "parse body with invalid numeric json" do
      body = 1
      httpoison_response = %HTTPoison.Response{status_code: 200, body: body}
      assert {:error, :body, :invalid_json} = Github.Response.parse_body(httpoison_response.body)
    end

    test "parse status" do
      body = %{"result" => "todo"}
      httpoison_response = %HTTPoison.Response{status_code: 200, body: body}

      assert {:ok, 200, :success} =
               Github.Response.parse_status(body, httpoison_response.status_code)
    end

    test "parse status when invalid status 500" do
      httpoison_response = %HTTPoison.Response{status_code: 500}

      assert {:error, :status, 500, :internal_server_error, [], nil} =
               Github.Response.parse_status(nil, httpoison_response.status_code)
    end

    test "parse status when invalid status 404" do
      body = %{"message" => "Not Found"}
      httpoison_response = %HTTPoison.Response{status_code: 404}

      assert {:error, :status, 404, :not_found, ["Not Found"], %{"message" => "Not Found"}} =
               Github.Response.parse_status(body, httpoison_response.status_code)
    end

    test "parse status when invalid status 300" do
      httpoison_response = %HTTPoison.Response{status_code: 300}

      assert {:error, :status, 300, :unhandled_error, [], nil} =
               Github.Response.parse_status(nil, httpoison_response.status_code)
    end

    test "map from HTTPoison response" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = {:ok, %HTTPoison.Response{status_code: 200, body: body}}

      assert %Github.Response{
               data: ^json,
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = Github.Response.from_httpoison(httpoison_response)
    end

    test "map from HTTPoison 404 error response" do
      body =
        "{\"message\":\"Not Found\",\"documentation_url\":\"https://docs.github.com/rest/repos/repos#get-a-repository\"}"

      httpoison_response = {:ok, %HTTPoison.Response{status_code: 404, body: body}}

      assert %Github.Response{
               data: %{
                 "message" => "Not Found",
                 "documentation_url" => _
               },
               status: 404,
               status_message: :not_found,
               errors: ["Not Found"],
               valid?: false
             } = Github.Response.from_httpoison(httpoison_response)
    end

    test "map from invalid HTTPoison body response" do
      body = "something"
      httpoison_response = {:ok, %HTTPoison.Response{status_code: 200, body: body}}

      assert %Github.Response{errors: ["body_invalid_json"], valid?: false} =
               Github.Response.from_httpoison(httpoison_response)
    end

    test "map from invalid HTTPoison status response" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = {:ok, %HTTPoison.Response{status_code: 500, body: body}}

      assert %Github.Response{
               errors: [],
               valid?: false,
               status_message: :internal_server_error,
               status: 500
             } =
               Github.Response.from_httpoison(httpoison_response)
    end

    test "map from HTTPoison Error" do
      httpoison_response = {:error, %HTTPoison.Error{reason: :nxdomain, __exception__: true}}

      assert %Github.Response{errors: ["exception_nxdomain"], valid?: false} =
               Github.Response.from_httpoison(httpoison_response)
    end

    test "aggregate responses" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      response = Github.Response.from_httpoison(httpoison_response)

      ten_json = Enum.map(1..10, fn _ -> json end)
      ten_response = Enum.map(1..10, fn _ -> response end)

      assert %Github.Response{
               data: ^ten_json,
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = Github.Response.aggregate_response(ten_response)
    end

    test "aggregate responses with failed" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = {:ok, %HTTPoison.Response{status_code: 200, body: body}}
      response = Github.Response.from_httpoison(httpoison_response)

      failed_httpoison_response =
        {:error, %HTTPoison.Error{reason: :nxdomain, __exception__: true}}

      failed_response = Github.Response.from_httpoison(failed_httpoison_response)

      ten_response = Enum.map(1..10, fn _ -> response end)

      assert %Github.Response{
               data: nil,
               status: 422,
               status_message: :unprocessable_content,
               errors: ["aggregation: There are invalids responses"],
               valid?: false
             } = Github.Response.aggregate_response([failed_response | ten_response])
    end
  end
end
