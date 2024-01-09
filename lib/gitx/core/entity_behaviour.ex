defmodule Gitx.Core.EntityBehaviour do
  @moduledoc """
    Behaviour for an Entity
  """
  @callback create(map()) :: {:ok, struct()} | {:error, field :: atom(), msg :: atom()}
end
