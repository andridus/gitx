defmodule Gitx.External.ResponseBehaviour do
  @moduledoc """
    Behaviour for a External Response
  """
  @type error_tuple ::
          {:error, :status, integer(), message :: atom(), errors :: list(String.t()),
           data :: map() | nil}
  @callback from_httpoison(HTTPoison.Response.t() | HTTPoison.Error.t()) :: struct()
  @callback parse_status(body :: term(), status :: integer()) ::
              {:ok, integer(), atom()} | error_tuple
  @callback parse_body(body :: term()) :: {:ok, term()} | {:error, :body, message :: atom()}
end
