defmodule Swapex.Validate do
  @moduledoc """
    Validate module to validate values in entities
  """

  def is_non_neg_integer(map, field) do
    value = map[field]

    cond do
      is_integer(value) && value > 0 -> {:ok, map}
      is_integer(value) && value < 0 -> {:error, field, :negative_integer}
      :else -> {:error, field, :invalid_number}
    end
  end

  def is_valid_non_empty_string(map, field) do
    value = map[field]

    cond do
      is_bitstring(value) && String.length(String.trim(value)) > 0 ->
        {:ok, map}

      is_bitstring(value) ->
        {:error, field, :empty_string}

      :else ->
        {:error, field, :invalid_string}
        # :else ->
    end
  end
end
