defmodule Swapex.DataCase do
  @moduledoc """
  This module defines the test for data sql context.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox
  alias Swapex.Repo

  using do
    quote do
      alias Swapex.Fixtures
      import Swapex.StructCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end
end
