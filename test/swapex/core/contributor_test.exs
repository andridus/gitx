defmodule Swapex.Core.ContributorTest do
  use Swapex.StructCase
  alias Swapex.Core.Contributor

  describe "Contributor Struct" do
    test "and create a new Contributor Struct" do
      fake_name = Faker.Person.name()
      fake_username = Faker.Internet.user_name()
      qtd_commits = :rand.uniform(100)

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
      fake_name = Faker.Person.name()
      fake_username = Faker.Internet.user_name()
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
      fake_username = Faker.Internet.user_name()
      qtd_commits = 1

      assert {:error, :name, :invalid_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and error when name is empty string" do
      fake_name = ""
      fake_username = Faker.Internet.user_name()
      qtd_commits = 1

      assert {:error, :name, :empty_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and error when user is empty string" do
      fake_name = Faker.Person.name()
      fake_username = ""
      qtd_commits = 1

      assert {:error, :user, :empty_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end

    test "and user is null" do
      fake_name = Faker.Person.name()
      fake_username = nil
      qtd_commits = 1

      assert {:error, :user, :invalid_string} =
               Contributor.create(%{
                 user: fake_username,
                 name: fake_name,
                 qtd_commits: qtd_commits
               })
    end
  end
end
