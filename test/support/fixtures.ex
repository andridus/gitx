defmodule Swapex.Fixtures do
  @moduledoc false

  alias Faker.{Commerce, Internet, Lorem, Person}

  @spec valid_list_of(:string, Range.t()) :: [String.t()] | [integer()]
  def valid_list_of(:string, rng \\ 2..6), do: Lorem.words(rng)

  @spec valid_name() :: String.t()
  def valid_name, do: Person.name()

  @spec valid_username() :: String.t()
  def valid_username, do: Internet.user_name()

  @spec valid_repo_name() :: String.t()
  def valid_repo_name, do: Faker.Internet.slug()

  @spec valid_integer_non_neg() :: integer()
  def valid_integer_non_neg, do: :rand.uniform(100)

  @spec valid_title() :: String.t()
  def valid_title, do: Commerce.PtBr.product_name()

  @spec datetime_before_days(integer()) :: String.t()
  def datetime_before_days(days \\ 1) do
    DateTime.utc_now() |> DateTime.add(-days, :day) |> DateTime.to_iso8601()
  end
end
