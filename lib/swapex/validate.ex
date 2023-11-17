defmodule Swapex.Validate do
  @moduledoc """
    Validate module to validate values in entities
  """

  @doc """
    Validates value integer from field in map.

    ## Examples

      iex> Swapex.Validate.is_non_neg_integer(%{a: 1}, :a)
      {:ok, %{a: 1}}
      iex> Swapex.Validate.is_non_neg_integer(%{a: -1}, :a)
      {:error, :a, :negative_integer}
  """
  def is_non_neg_integer(map, field) do
    value = map[field]

    cond do
      is_integer(value) && value > 0 -> {:ok, map}
      is_integer(value) && value < 0 -> {:error, field, :negative_integer}
      :else -> {:error, field, :invalid_number}
    end
  end

  @doc """
    Validates value when string from field in map.

    ## Examples

      iex> Swapex.Validate.is_valid_non_empty_string(%{a: "a string"}, :a)
      {:ok, %{a: "a string"}}
      iex> Swapex.Validate.is_valid_non_empty_string(%{a: ""}, :a)
      {:error, :a, :empty_string}
      iex> Swapex.Validate.is_valid_non_empty_string(%{a: 1}, :a)
      {:error, :a, :invalid_string}
  """
  def is_valid_non_empty_string(map, field) do
    value = map[field]

    cond do
      is_bitstring(value) && String.length(String.trim(value)) > 0 ->
        {:ok, map}

      is_bitstring(value) ->
        {:error, field, :empty_string}

      :else ->
        {:error, field, :invalid_string}
    end
  end

  @doc """
  Validates value in a list of (function evaluation)

  ## Examples

    iex> Swapex.Validate.is_valid_list_of(%{a: [1,2,3]}, :a, &is_integer/1)
    {:ok, %{a: [1,2,3]}}
    iex> Swapex.Validate.is_valid_list_of(%{a: ["a",2,3]}, :a, &is_integer/1)
    {:error, :a, :invalid_item_list}
    iex> Swapex.Validate.is_valid_list_of(%{a: 1}, :a, &is_integer/1)
    {:error, :a, :invalid_list}
    iex> Swapex.Validate.is_valid_list_of(%{a: []}, :a, &is_integer/1)
    {:ok, %{a: []}}
  """
  def is_valid_list_of(map, field, fun) do
    value = map[field]

    cond do
      is_list(value) && Enum.all?(value, fun) ->
        {:ok, map}

      is_list(value) ->
        {:error, field, :invalid_item_list}

      :else ->
        {:error, field, :invalid_list}
    end
  end
end
