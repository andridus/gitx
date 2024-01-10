defmodule Gitx.Jobs.Webhook.PushJob do
  @moduledoc """
    Webhook Job to push data to Webhook.Api
  """
  use Oban.Worker, queue: :webhook

  alias Gitx.External.Webhook

  @impl Oban.Worker
  def perform(%Oban.Job{args: params}) do
    Webhook.Api.push(params)
  end
end
