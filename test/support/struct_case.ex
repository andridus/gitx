defmodule Swapex.StructCase do
  @moduledoc """
  This module defines the test for core or context only.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Swapex.Fixtures
      import Swapex.StructCase
    end
  end

  setup _tags do
    :ok
  end
end
