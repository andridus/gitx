defmodule Swapex.Core.GithubRepo do
  @moduledoc """
    GithubRepo Struct
  """

  alias Swapex.Validate
  alias Swapex.Core.{Contributor, Issue}

  @type t :: %__MODULE__{
          user: String.t(),
          repo: String.t(),
          issues: [Issue.t()],
          contributors: [Contributor.t()]
        }

  defstruct user: "",
            repo: "",
            issues: [],
            contributors: []

  def create(map) do
    with {:ok, map} <- Validate.is_valid_non_empty_string(map, :user),
         {:ok, map} <- Validate.is_valid_slug(map, :repo),
         {:ok, map} <- Validate.is_valid_list_of(map, :issues, &(&1.__struct__ == Issue)),
         {:ok, map} <-
           Validate.is_valid_list_of(map, :contributors, &(&1.__struct__ == Contributor)) do
      {:ok, struct(__MODULE__, map)}
    else
      {:error, field, msg} -> {:error, field, msg}
    end
  end
end
