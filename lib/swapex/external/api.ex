defmodule Swapex.External.Api do
  @moduledoc """
    Default behaviour for HTTPoison
  """

  defmacro __using__(endpoint: endpoint) do
    quote bind_quoted: [endpoint: endpoint] do
      alias Swapex.External.Api

      @spec get(path :: String.t()) ::
              {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
      def get(path) do
        Api.httpoison_get(unquote(endpoint) <> path)
      end
    end
  end

  @spec httpoison_get(url :: String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def httpoison_get(url) do
    HTTPoison.get(url)
  end

  @spec label_from_status(status :: integer()) :: message :: term()
  def label_from_status(status) do
    case status do
      200 -> :success
      500 -> :internal_server_error
      404 -> :not_found
      _ -> :unhandled_error
    end
  end
end
