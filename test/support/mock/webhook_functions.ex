defmodule Gitx.Mock.WebhookFunctions do
  @moduledoc """
    Functions to endpoint Webhook in Mock
  """
  alias Gitx.Mock.State

  def post_push(conn, %{"uuid" => uuid} = params) do
    State.access(conn.url)
    |> case do
      :ok ->
        data = Map.drop(params, ["uuid"])

        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "This URL has no default content configured. <a href=\"https://webhook.site/#!/#{uuid}\">View in Webhook.site</a>.",
           headers: [
             {"Server", "nginx"},
             {"Content-Type", "text/html; charset=UTF-8"},
             {"Transfer-Encoding", "chunked"},
             {"Vary", "Accept-Encoding"},
             {"X-Token-Id", "#{uuid}"},
             {"Cache-Control", "no-cache, private"}
           ],
           request_url: "https://webhook.site/#{uuid}",
           request: %HTTPoison.Request{
             method: :post,
             url: "https://webhook.site/#{uuid}",
             headers: [{"content-type", "application/json"}],
             body: data,
             params: %{},
             options: []
           }
         }}

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}

      :rate_limit ->
        {:ok,
         %HTTPoison.Response{
           status_code: 403,
           body: "example rate limit",
           request_url: conn.url,
           request: %HTTPoison.Request{
             method: :post,
             url: conn.url
           }
         }}
    end
  end
end
