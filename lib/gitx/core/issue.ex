defmodule Gitx.Core.Issue do
  @moduledoc """
    GithubRepo Issue
  """
  @behaviour Gitx.Core.EntityBehaviour
  alias Gitx.Validate

  @type t :: %__MODULE__{
          title: String.t(),
          author: String.t(),
          labels: [String.t()]
        }

  @derive {Jason.Encoder, only: [:title, :author, :labels]}
  defstruct title: "",
            author: "",
            labels: []

  def create(map) do
    with {:ok, map} <- Validate.is_valid_list_of(map, :labels, &is_bitstring/1),
         {:ok, map} <- Validate.is_valid_non_empty_string(map, :title),
         {:ok, map} <- Validate.is_valid_non_empty_string(map, :author) do
      {:ok, struct(__MODULE__, map)}
    end
  end
end
