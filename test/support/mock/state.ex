defmodule Gitx.Mock.State do
  @moduledoc """
    State for manipulate mock test based
  """
  alias Gitx.Fixtures
  use HTTPMock.State

  entity(:request, default: [], key: :id)
  entity(:limits, default: [], key: :id)
  entity(:contributors, default: [], key: "id")
  entity(:issues, default: [], key: "id")

  def set_pages(total) do
    delete(:pages, 1)
    create(:pages, %{id: 1, total: total})
  end

  def set_rate_limit(limit) do
    delete(:limits, 1)
    create(:limits, %{id: 1, limit: limit, type: :rate_limit})
  end

  def set_nxdomain do
    delete(:limits, 1)
    create(:limits, %{id: 1, limit: 0, type: :nxdomain})
  end

  def access(endpoint) do
    one(:limits, 1)
    |> case do
      nil ->
        :ok

      %{type: :nxdomain} ->
        :nxdomain

      %{type: :rate_limit} = limit ->
        all_requests = all(:request) |> length()

        if all_requests < limit.limit do
          id = Faker.UUID.v4()
          create(:request, %{id: id, endpoint: endpoint, created_at: DateTime.utc_now()})
          :ok
        else
          reset()
          set_rate_limit(limit.limit)
          :rate_limit
        end
    end
  end

  def set_contributors(username, repo, range) do
    total = all_contributors(repo, {50_000, 1}) |> Enum.count()

    if Enum.count(range) > 0 do
      owner =
        one_user(username)
        |> Map.put("contributions", 10)
        |> Map.put("id", 1)
        |> Map.put("repo", repo)

      create(:contributors, owner)
    end

    for {_, i} <- Enum.drop(range, 1) |> Enum.with_index(total) do
      contrib =
        one_user(Fixtures.valid_username())
        |> Map.put("contributions", 10)
        |> Map.put("id", i + 1)
        |> Map.put("repo", repo)

      create(:contributors, contrib)
    end

    :ok
  end

  def all_contributors(repo, {per_page, page}) do
    all(:contributors)
    |> Enum.filter(&(&1["repo"] == repo))
    |> Enum.drop((page - 1) * per_page)
    |> Enum.take(per_page)
  end

  def set_issues(username, repo, state, has_labels?, range \\ 1..5) do
    total = all_issues(repo, state, {50_000, 1}) |> Enum.count()

    for {_, i} <- Enum.with_index(range, total) do
      issue =
        one_issue(i + 1, username, repo, state, has_labels?)
        |> Map.put("id", i + 1)
        |> Map.put("repo", repo)

      create(:issues, issue)
    end

    :ok
  end

  def all_issues(repo, state, {per_page, page}) do
    all(:issues)
    |> Enum.filter(&(&1["repo"] == repo && &1["state"] == state))
    |> Enum.drop((page - 1) * per_page)
    |> Enum.take(per_page)
  end

  def one_repo(username, repo) do
    repo_url = "https://api.github.com/repos/#{username}/#{repo}"

    %{
      "id" => :rand.uniform(500_000),
      "node_id" => "R_kgDOJe2sNQ",
      "name" => repo,
      "full_name" => "#{username}/#{repo}",
      "private" => false,
      "owner" => one_user(username),
      "html_url" => "https://github.com/#{username}/#{repo}",
      "description" => Faker.Lorem.paragraph(),
      "fork" => false,
      "url" => repo_url,
      "forks_url" => "#{repo_url}/forks",
      "keys_url" => "#{repo_url}/keys{/key_id}",
      "collaborators_url" => "#{repo_url}/collaborators{/collaborator}",
      "teams_url" => "#{repo_url}/teams",
      "hooks_url" => "#{repo_url}/hooks",
      "issue_events_url" => "#{repo_url}/issues/events{/number}",
      "events_url" => "#{repo_url}/events",
      "assignees_url" => "#{repo_url}/assignees{/user}",
      "branches_url" => "#{repo_url}/branches{/branch}",
      "tags_url" => "#{repo_url}/tags",
      "blobs_url" => "#{repo_url}/git/blobs{/sha}",
      "git_tags_url" => "#{repo_url}/git/tags{/sha}",
      "git_refs_url" => "#{repo_url}/git/refs{/sha}",
      "trees_url" => "#{repo_url}/git/trees{/sha}",
      "statuses_url" => "#{repo_url}/statuses/{sha}",
      "languages_url" => "#{repo_url}/languages",
      "stargazers_url" => "#{repo_url}/stargazers",
      "contributors_url" => "#{repo_url}/contributors",
      "subscribers_url" => "#{repo_url}/subscribers",
      "subscription_url" => "#{repo_url}/subscription",
      "commits_url" => "#{repo_url}/commits{/sha}",
      "git_commits_url" => "#{repo_url}/git/commits{/sha}",
      "comments_url" => "#{repo_url}/comments{/number}",
      "issue_comment_url" => "#{repo_url}/issues/comments{/number}",
      "contents_url" => "#{repo_url}/contents/{+path}",
      "compare_url" => "#{repo_url}/compare/{base}...{head}",
      "merges_url" => "#{repo_url}/merges",
      "archive_url" => "#{repo_url}/{archive_format}{/ref}",
      "downloads_url" => "#{repo_url}/downloads",
      "issues_url" => "#{repo_url}/issues{/number}",
      "pulls_url" => "#{repo_url}/pulls{/number}",
      "milestones_url" => "#{repo_url}/milestones{/number}",
      "notifications_url" => "#{repo_url}/notifications{?since,all,participating}",
      "labels_url" => "#{repo_url}/labels{/name}",
      "releases_url" => "#{repo_url}/releases{/id}",
      "deployments_url" => "#{repo_url}/deployments",
      "created_at" => Fixtures.datetime_before_days(-4),
      "updated_at" => Fixtures.datetime_before_days(-3),
      "pushed_at" => Fixtures.datetime_before_days(-3),
      "git_url" => "git://github.com/#{username}/#{repo}.git",
      "ssh_url" => "git@github.com:#{username}/#{repo}.git",
      "clone_url" => "https://github.com/#{username}/#{repo}.git",
      "svn_url" => "https://github.com/#{username}/#{repo}",
      "homepage" => "",
      "size" => 2074,
      "stargazers_count" => 7,
      "watchers_count" => 7,
      "language" => "V",
      "has_issues" => true,
      "has_projects" => true,
      "has_downloads" => true,
      "has_wiki" => true,
      "has_pages" => false,
      "has_discussions" => false,
      "forks_count" => 0,
      "mirror_url" => nil,
      "archived" => false,
      "disabled" => false,
      "open_issues_count" => 1,
      "license" => %{
        "key" => "mit",
        "name" => "MIT License",
        "spdx_id" => "MIT",
        "url" => "https://api.github.com/licenses/mit",
        "node_id" => "MDc6TGljZW5zZTEz"
      },
      "allow_forking" => true,
      "is_template" => false,
      "web_commit_signoff_required" => false,
      "topics" => [],
      "visibility" => "public",
      "forks" => 0,
      "open_issues" => 1,
      "watchers" => 7,
      "default_branch" => "development",
      "temp_clone_token" => nil,
      "network_count" => 0,
      "subscribers_count" => 0
    }
  end

  def one_user(username) do
    url = "https://api.github.com/users/#{username}"

    %{
      "login" => "#{username}",
      "id" => :rand.uniform(500_000),
      "node_id" => "MDQ6VXNlcjU5MDE0NzE=",
      "avatar_url" => "https://avatars.githubusercontent.com/u/5901471?v=4",
      "gravatar_id" => "",
      "url" => url,
      "html_url" => "https://github.com/#{username}",
      "followers_url" => "#{url}/followers",
      "following_url" => "#{url}/following{/other_user}",
      "gists_url" => "#{url}/gists{/gist_id}",
      "starred_url" => "#{url}/starred{/owner}{/repo}",
      "subscriptions_url" => "#{url}/subscriptions",
      "organizations_url" => "#{url}/orgs",
      "repos_url" => "#{url}/repos",
      "events_url" => "#{url}/events{/privacy}",
      "received_events_url" => "#{url}/received_events",
      "type" => "User",
      "site_admin" => false
    }
  end

  defp one_issue(number, username, repo, state, has_labels?) do
    repo_url = "https://api.github.com/repos/#{username}/#{repo}"

    %{
      "url" => "#{repo_url}/issues/1",
      "repository_url" => "#{repo_url}",
      "labels_url" => "#{repo_url}/issues/1/labels{/name}",
      "comments_url" => "#{repo_url}/issues/1/comments",
      "events_url" => "#{repo_url}/issues/1/events",
      "html_url" => "https://github.com/#{username}/#{repo}/issues/1",
      "id" => Fixtures.valid_integer_non_neg(),
      "node_id" => "I_kwDOJe2sNc5nKpVQ",
      "number" => number,
      "title" => Faker.Lorem.sentence(),
      "user" => one_user(username),
      "labels" =>
        if(has_labels?,
          do: [
            %{
              "id" => 91_041_697,
              "node_id" => "MDU6TGFiZWw5MTA0MTY5Nw==",
              "url" => "https://api.github.com/repos/elixirs/faker/labels/help%20wanted",
              "name" => "help wanted",
              "color" => "159818",
              "default" => true,
              "description" => nil
            },
            %{
              "id" => 717_663_203,
              "node_id" => "MDU6TGFiZWw3MTc2NjMyMDM=",
              "url" => "https://api.github.com/repos/elixirs/faker/labels/good%20first%20issue",
              "name" => "good first issue",
              "color" => "d4c5f9",
              "default" => true,
              "description" => nil
            }
          ],
          else: []
        ),
      "state" => state,
      "locked" => false,
      "assignee" => nil,
      "assignees" => [],
      "milestone" => nil,
      "comments" => 0,
      "created_at" => "2023-05-29T14:16:11Z",
      "updated_at" => "2023-05-29T14:16:11Z",
      "closed_at" => nil,
      "author_association" => "OWNER",
      "active_lock_reason" => nil,
      "body" => Faker.Lorem.sentence(),
      "reactions" => %{
        "url" => "#{repo_url}/issues/1/reactions",
        "total_count" => 0,
        "+1" => 0,
        "-1" => 0,
        "laugh" => 0,
        "hooray" => 0,
        "confused" => 0,
        "heart" => 0,
        "rocket" => 0,
        "eyes" => 0
      },
      "timeline_url" => "#{repo_url}/issues/1/timeline",
      "performed_via_github_app" => nil,
      "state_reason" => nil
    }
  end
end
