defmodule GitxWeb.SchedulerController do
  use GitxWeb, :controller
  alias Gitx.Context.SchedulerContext

  def schedule(conn, params) do
    params
    |> SchedulerContext.to_fetch_repository()
    |> case do
      {:ok, _} -> conn |> json(%{success: :scheduled})
      {:error, msg} -> conn |> put_status(422) |> json(%{error: msg})
    end
  end
end
