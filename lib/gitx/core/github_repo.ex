defmodule Gitx.Core.GithubRepo do
  @moduledoc """
    GithubRepo Struct
  """
  @behaviour Gitx.Core.EntityBehaviour
  alias Gitx.Validate
  alias Gitx.Core.{Contributor, Issue}

  @type t :: %__MODULE__{
          user: String.t(),
          repo: String.t(),
          issues: [Issue.t()],
          contributors: [Contributor.t()]
        }

  @derive {Jason.Encoder, only: [:user, :repo, :issues, :contributors]}
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
    end
  end
end
