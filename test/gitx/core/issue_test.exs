defmodule Gitx.Core.IssueTest do
  use Gitx.StructCase
  alias Gitx.Core.Issue

  describe "Issue Struct" do
    test "and create a new Issue Struct" do
      fake_title = Fixtures.valid_title()
      fake_author = Fixtures.valid_name()
      fake_labels = Fixtures.valid_list_of(:string, 2..4)

      assert {:ok, issue} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })

      assert ^fake_title = issue.title
      assert ^fake_author = issue.author
      assert ^fake_labels = issue.labels
    end

    test "and success when labels is an empty list" do
      fake_title = Fixtures.valid_title()
      fake_author = Fixtures.valid_name()
      fake_labels = []

      assert {:ok, _issue} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end

    test "and error when labels is not a list" do
      fake_title = Fixtures.valid_title()
      fake_author = Fixtures.valid_name()
      fake_labels = :tag

      assert {:error, :labels, :invalid_list} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end

    test "and error when labels is nil" do
      fake_title = Fixtures.valid_title()
      fake_author = Fixtures.valid_name()
      fake_labels = nil

      assert {:error, :labels, :invalid_list} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end

    test "and error when title is null" do
      fake_title = nil
      fake_author = Fixtures.valid_name()
      fake_labels = Fixtures.valid_list_of(:string, 2..4)

      assert {:error, :title, :invalid_string} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end

    test "and error when title is invalid string" do
      fake_title = ""
      fake_author = Fixtures.valid_name()
      fake_labels = Fixtures.valid_list_of(:string, 2..4)

      assert {:error, :title, :empty_string} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end

    test "and error when author is null" do
      fake_title = Fixtures.valid_title()
      fake_author = nil
      fake_labels = Fixtures.valid_list_of(:string, 2..4)

      assert {:error, :author, :invalid_string} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end

    test "and error when author is invalid string" do
      fake_title = Fixtures.valid_title()
      fake_author = ""
      fake_labels = Fixtures.valid_list_of(:string, 2..4)

      assert {:error, :author, :empty_string} =
               Issue.create(%{
                 title: fake_title,
                 author: fake_author,
                 labels: fake_labels
               })
    end
  end
end
