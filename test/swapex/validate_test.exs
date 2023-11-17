defmodule Swapex.ValidateTest do
  use Swapex.StructCase

  alias Swapex.Validate

  describe "Validate is_non_negative_integer" do
    test "obtains success when value is positive" do
      field = :common_field
      map = %{field => 1}

      assert {:ok, ^map} = Validate.is_non_neg_integer(map, field)
    end

    test "obtains error when value is null" do
      field = :common_field
      map = %{field => nil}

      assert {:error, :common_field, :invalid_number} = Validate.is_non_neg_integer(map, field)
    end

    test "obtains error when value is negative" do
      field = :common_field
      map = %{field => -1}

      assert {:error, :common_field, :negative_integer} = Validate.is_non_neg_integer(map, field)
    end
  end

  describe "Validate is_valid_non_empty_string" do
    test "obtains success when value is a valid string" do
      field = :common_field
      map = %{field => Faker.Person.name()}

      assert {:ok, ^map} = Validate.is_valid_non_empty_string(map, field)
    end

    test "obtains error when value is null" do
      field = :common_field
      map = %{field => nil}

      assert {:error, :common_field, :invalid_string} =
               Validate.is_valid_non_empty_string(map, field)
    end

    test "obtains error when value is an empty string" do
      field = :common_field

      for value <- ["", " ", "  "] do
        map = %{field => value}

        assert {:error, :common_field, :empty_string} =
                 Validate.is_valid_non_empty_string(map, field)
      end
    end
  end
end