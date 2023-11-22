defmodule Swapex.External.Webhook.Api do
  @moduledoc """
    Webhook Api to push data
  """
  use Swapex.External.Api, endpoint: "https://webhook.site/"

  @id "7bed3493-18fb-4b78-827b-d19a95207211"

  @doc """
    Post push data to wehbook
    params
      data: GithubRepo.t()
  """

  @spec(push(data :: map()) :: :ok, {:error, String.t()})
  def push(%{"user" => _, "repo" => _, "issues" => _, "contributors" => _} = data) do
    post(@id, data)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, %HTTPoison.Response{status_code: status}} -> {:error, Api.label_from_status(status)}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  def push(_data) do
    {:error, :invalid_struct}
  end
end
