defmodule Swapex.Mock.GithubFunctions do
  @moduledoc """
    Functions to endpoint Github in Mock
  """
  alias Swapex.Fixtures

  def get_user(_conn, %{"username" => username}) do
    url = "https://api.github.com/users/#{username}"

    data =
      %{
        login: username,
        id: :rand.uniform(500_000),
        node_id: Faker.UUID.v4(),
        avatar_url: "https://avatars.githubusercontent.com/u/5901471?v=4",
        gravatar_id: "",
        url: url,
        html_url: "https://github.com/#{username}",
        followers_url: "#{url}/followers",
        following_url: "#{url}/following{/other_user}",
        gists_url: "#{url}/gists{/gist_id}",
        starred_url: "#{url}/starred{/owner}{/repo}",
        subscriptions_url: "#{url}/subscriptions",
        organizations_url: "#{url}/orgs",
        repos_url: "#{url}/repos",
        events_url: "#{url}/events{/privacy}",
        received_events_url: "#{url}/received_events",
        type: "User",
        site_admin: false,
        name: Faker.Person.PtBr.name(),
        company: nil,
        blog: "",
        location: Faker.Address.PtBr.country() <> "/" <> Faker.Address.PtBr.city(),
        email: nil,
        hireable: nil,
        bio: Faker.Lorem.paragraph(1..2),
        twitter_username: nil,
        public_repos: 50,
        public_gists: 0,
        followers: 14,
        following: 4,
        created_at: Fixtures.datetime_before_days(-5),
        updated_at: Fixtures.datetime_before_days(-1)
      }
      |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 200}}
  end

  def get_repo(_conn, %{"repo" => "not-found", "username" => _username}) do
    data =
      %{
        "documentation_url" => "https://docs.github.com/rest/repos/repos#get-a-repository",
        "message" => "Not Found"
      }
      |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 404}}
  end

  def get_repo(_conn, %{"repo" => repo, "username" => username}) do
    repo_url = "https://api.github.com/repos/#{username}/#{repo}"

    data =
      %{
        "id" => :rand.uniform(500_000),
        "node_id" => "R_kgDOJe2sNQ",
        "name" => repo,
        "full_name" => "#{username}/#{repo}",
        "private" => false,
        "ower" => user(username),
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
      |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 200}}
  end

  def get_repo_issues(_conn, %{"repo" => "not-found", "username" => _username}) do
    data =
      %{
        "documentation_url" =>
          "https://docs.github.com/rest/issues/issues#list-repository-issues",
        "message" => "Not Found"
      }
      |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 404}}
  end

  def get_repo_issues(_conn, %{"repo" => repo, "username" => username}) do
    repo_url = "https://api.github.com/repos/#{username}/#{repo}"

    one =
      %{
        "url" => "#{repo_url}/issues/1",
        "repository_url" => "#{repo_url}",
        "labels_url" => "#{repo_url}/issues/1/labels{/name}",
        "comments_url" => "#{repo_url}/issues/1/comments",
        "events_url" => "#{repo_url}/issues/1/events",
        "html_url" => "https://github.com/#{username}/#{repo}/issues/1",
        "id" => Fixtures.valid_integer_non_neg(),
        "node_id" => "I_kwDOJe2sNc5nKpVQ",
        "number" => 1,
        "title" => Faker.Lorem.sentence(),
        "user" => user(username),
        "labels" => [],
        "state" => "open",
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

    data = [one] |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 200}}
  end

  def get_repo_contributors(_conn, %{"repo" => "not-found", "username" => _username}) do
    data =
      %{
        "documentation_url" =>
          "https://docs.github.com/rest/contributors/contributors#list-repository-contributors",
        "message" => "Not Found"
      }
      |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 404}}
  end

  def get_repo_contributors(_conn, %{"repo" => _repo, "username" => username}) do
    data = [user(username)] |> Jason.encode!()

    {:ok, %HTTPoison.Response{body: data, status_code: 200}}
  end

  defp user(username) do
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
end
