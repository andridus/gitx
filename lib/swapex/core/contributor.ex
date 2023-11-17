defmodule Swapex.Core.Contributor do
  @moduledoc """
    Contributor Struct
  """

  alias Swapex.Validate

  @type t :: %__MODULE__{
          name: String.t(),
          user: String.t(),
          qtd_commits: non_neg_integer()
        }

  defstruct name: "",
            user: "",
            qtd_commits: 0

  def create(map) do
    with {:ok, map} <- Validate.is_non_neg_integer(map, :qtd_commits),
         {:ok, map} <- Validate.is_valid_non_empty_string(map, :name),
         {:ok, map} <- Validate.is_valid_non_empty_string(map, :user) do
      {:ok, struct(__MODULE__, map)}
    else
      {:error, field, msg} -> {:error, field, msg}
    end
  end
end
