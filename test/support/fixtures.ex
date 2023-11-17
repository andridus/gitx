defmodule Swapex.Fixtures do
  @moduledoc false

  alias Faker.{Commerce, Internet, Lorem, Person}

  @spec valid_list_of(:string | :integer, Range.t()) :: [String.t()] | [integer()]
  def valid_list_of(_term, _range \\ 2..6)
  def valid_list_of(:string, rng), do: Lorem.words(rng)
  def valid_list_of(:integer, rng), do: rng |> Enum.map(& &1)

  @spec valid_name() :: String.t()
  def valid_name, do: Person.name()

  @spec valid_username() :: String.t()
  def valid_username, do: Internet.user_name()

  @spec valid_repo_name() :: String.t()
  def valid_repo_name, do: Faker.Internet.slug()

  @spec valid_integer_non_neg() :: integer()
  def valid_integer_non_neg, do: :rand.uniform(100)

  @spec valid_username() :: String.t()
  def valid_title, do: Commerce.PtBr.product_name()
end
