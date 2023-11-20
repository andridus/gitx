defmodule Swapex.External.Github.Response do
  @moduledoc """
    Response from Github API
  """
  alias Swapex.External.Api
  @behaviour Swapex.External.ResponseBehaviour

  @type t :: %__MODULE__{
          data: map() | integer() | String.t() | nil,
          status: non_neg_integer(),
          status_message: atom(),
          errors: [String.t()],
          valid?: boolean()
        }

  defstruct data: nil, status: 0, status_message: :none, errors: [], valid?: false

  def from_httpoison({_, %HTTPoison.Response{} = response}) do
    with {:ok, body} <- parse_body(response.body),
         {:ok, status, status_msg} <- parse_status(body, response.status_code) do
      struct(__MODULE__, %{data: body, status: status, status_message: status_msg, valid?: true})
    else
      {:error, :body, error_msg} ->
        struct(__MODULE__, %{errors: ["body_#{error_msg}"], valid?: false})

      {:error, :status, status, status_msg, message, data} ->
        struct(__MODULE__, %{
          data: data,
          errors: message,
          status: status,
          status_message: status_msg,
          valid?: false
        })
    end
  end

  def from_httpoison({_, %HTTPoison.Error{reason: reason}}) do
    struct(__MODULE__, %{errors: ["exception_#{reason}"], valid?: false})
  end

  def parse_body(body_response) do
    json = Jason.decode!(body_response)
    {:ok, json}
  rescue
    _error -> {:error, :body, :invalid_json}
  end

  def parse_status(body, status) when is_list(body) and status == 200 do
    {:ok, status, Api.label_from_status(status)}
  end

  def parse_status(body, status) when is_map(body) or is_nil(body) do
    message = body["message"] || []
    errors = body["errors"] || []

    if status in [200] && Enum.empty?(errors) do
      {:ok, status, Api.label_from_status(status)}
    else
      message = List.flatten([message])
      {:error, :status, status, Api.label_from_status(status), message, body}
    end
  end
end
