defmodule Gitx.Jobs.Webhook.PushJob do
  @moduledoc """
    Webhook Job to push data to Webhook.Api
  """
  use Oban.Worker, queue: :webhook

  alias Gitx.External.Webhook

  @impl Oban.Worker
  def perform(%Oban.Job{args: params}) do
    case Webhook.Api.push(params) do
      :ok ->
        :ok

      error ->
        :error
    end
  end
end
