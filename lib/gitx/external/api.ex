defmodule Gitx.External.Api do
  @moduledoc """
    Default behaviour for HTTPoison
  """

  defmacro __using__(endpoint: endpoint) do
    quote bind_quoted: [endpoint: endpoint] do
      alias Gitx.External.Api

      @spec get(path :: String.t()) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
      def get(path) do
        Api.httpoison_get(unquote(endpoint) <> path)
      end

      @spec post(path :: String.t(), params :: map()) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
      def post(path, params) do
        Api.httpoison_post(unquote(endpoint) <> path, params)
      end
    end
  end

  @spec httpoison_get(url :: String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def httpoison_get(url) do
    HTTPoison.get(url)
  end

  @spec httpoison_post(url :: String.t(), params :: map()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def httpoison_post(url, params) do
    data = Jason.encode!(params)
    HTTPoison.post(url, data)
  end

  @spec label_from_status(status :: integer()) :: message :: term()
  def label_from_status(status) do
    case status do
      200 -> :success
      500 -> :internal_server_error
      404 -> :not_found
      403 -> :unauthorized
      _ -> :unhandled_error
    end
  end
end
