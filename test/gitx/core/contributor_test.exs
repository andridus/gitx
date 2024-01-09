defmodule Gitx.Core.ContributorTest do
  use Gitx.StructCase
  alias Gitx.Core.Contributor

  describe "Contributor Struct" do
    test "and create a new Contributor Struct" do
      fake_name = Fixtures.valid_name()
      fake_username = Fixtures.valid_username()
      qtd_commits = Fixtures.valid_integer_non_neg()

      assert {:ok, contributor} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })

      assert ^fake_username = contributor.user
      assert ^fake_name = contributor.name
      assert ^qtd_commits = contributor.qtd_commits
    end

    test "and error when qtd_commits is null" do
      fake_name = Fixtures.valid_name()
      fake_username = Fixtures.valid_username()
      qtd_commits = nil

      assert {:error, :qtd_commits, :invalid_number} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and error when name is null" do
      fake_name = nil
      fake_username = Fixtures.valid_username()
      qtd_commits = Fixtures.valid_integer_non_neg()

      assert {:error, :name, :invalid_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and error when name is empty string" do
      fake_name = ""
      fake_username = Fixtures.valid_username()
      qtd_commits = Fixtures.valid_integer_non_neg()

      assert {:error, :name, :empty_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and error when user is empty string" do
      fake_name = Fixtures.valid_name()
      fake_username = ""
      qtd_commits = Fixtures.valid_integer_non_neg()

      assert {:error, :user, :empty_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and user is null" do
      fake_name = Fixtures.valid_name()
      fake_username = nil
      qtd_commits = Fixtures.valid_integer_non_neg()

      assert {:error, :user, :invalid_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end
  end
end
