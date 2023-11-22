defmodule Swapex.External.Webhook.Api do
  @moduledoc """
    Webhook Api to push data
  """
  use Swapex.External.Api, endpoint: "https://webhook.site/"

  @doc """
    Post push data to wehbook
    params
      data: GithubRepo.t()
  """
  @spec(push(data :: map()) :: :ok, {:error, String.t()})
  def push(%{"user" => _, "repo" => _, "issues" => _, "contributors" => _} = data) do
    webhook_id()
    |> post(data)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, %HTTPoison.Response{status_code: status}} -> {:error, Api.label_from_status(status)}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  def push(_data) do
    {:error, :invalid_struct}
  end

  defp webhook_id, do: Application.get_env(:swapex, :webhook_id)
end
