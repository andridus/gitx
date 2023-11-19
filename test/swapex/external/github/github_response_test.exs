defmodule Swapex.External.Github.ReponseTest do
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
      httpoison_response = %HTTPoison.Response{status_code: 200}
      assert {:ok, 200, :success} = Github.Response.parse_status(httpoison_response.status_code)
    end

    test "parse status when invalid status 500" do
      httpoison_response = %HTTPoison.Response{status_code: 500}

      assert {:error, :status, :internal_server_error} =
               Github.Response.parse_status(httpoison_response.status_code)
    end

    test "parse status when invalid status 404" do
      httpoison_response = %HTTPoison.Response{status_code: 404}

      assert {:error, :status, :not_found} =
               Github.Response.parse_status(httpoison_response.status_code)
    end

    test "parse status when invalid status 300" do
      httpoison_response = %HTTPoison.Response{status_code: 300}

      assert {:error, :status, :unhandled_error_300} =
               Github.Response.parse_status(httpoison_response.status_code)
    end

    test "map from HTTPoison response" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = %HTTPoison.Response{status_code: 200, body: body}

      assert %Github.Response{
               data: ^json,
               status: 200,
               status_message: :success,
               errors: [],
               valid?: true
             } = Github.Response.from_httpoison(httpoison_response)
    end

    test "map from invalid HTTPoison body response" do
      body = "something"
      httpoison_response = %HTTPoison.Response{status_code: 200, body: body}

      assert %Github.Response{errors: ["body_invalid_json"], valid?: false} =
               Github.Response.from_httpoison(httpoison_response)
    end

    test "map from invalid HTTPoison status response" do
      json = %{"result" => "todo"}
      {:ok, body} = Jason.encode(json)
      httpoison_response = %HTTPoison.Response{status_code: 500, body: body}

      assert %Github.Response{errors: ["status_internal_server_error"], valid?: false} =
               Github.Response.from_httpoison(httpoison_response)
    end

    test "map from HTTPoison Error" do
      httpoison_response = %HTTPoison.Error{reason: :nxdomain, __exception__: true}

      assert %Github.Response{errors: ["exception_nxdomain"], valid?: false} =
               Github.Response.from_httpoison(httpoison_response)
    end
  end
end
