defmodule Swapex.External.ResponseBehaviour do
  @moduledoc """
    Behaviour for a External Response
  """
  @callback from_httpoison(HTTPoison.Response.t() | HTTPoison.Error.t()) :: struct()
  @callback parse_status(status :: integer()) ::
              {:ok, integer()} | {:error, :status, message :: atom()}
  @callback parse_body(body :: term) :: {:ok, term()} | {:error, :body, message :: atom()}
end
