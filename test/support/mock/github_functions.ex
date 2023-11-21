defmodule Swapex.Mock.GithubFunctions do
  @moduledoc """
    Functions to endpoint Github in Mock
  """
  alias Swapex.Fixtures
  alias Swapex.Mock.State

  def get_user(conn, %{"username" => username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        data =
          Map.merge(
            user(username),
            %{
              "name" => Faker.Person.PtBr.name(),
              "company" => nil,
              "blog" => "",
              "location" => Faker.Address.PtBr.country() <> "/" <> Faker.Address.PtBr.city(),
              "email" => nil,
              "hireable" => nil,
              "bio" => Faker.Lorem.paragraph(1..2),
              "twitter_username" => nil,
              "public_repos" => 50,
              "public_gists" => 0,
              "followers" => 14,
              "following" => 4,
              "created_at" => Fixtures.datetime_before_days(-5),
              "updated_at" => Fixtures.datetime_before_days(-1)
            }
          )
          |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def get_repo(conn, %{"repo" => "not-found", "username" => _username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        data =
          %{
            "documentation_url" => "https://docs.github.com/rest/repos/repos#get-a-repository",
            "message" => "Not Found"
          }
          |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 404}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def get_repo(conn, %{"repo" => repo, "username" => username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        repo_url = "https://api.github.com/repos/#{username}/#{repo}"

        data =
          %{
            "id" => :rand.uniform(500_000),
            "node_id" => "R_kgDOJe2sNQ",
            "name" => repo,
            "full_name" => "#{username}/#{repo}",
            "private" => false,
            "owner" => user(username),
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

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def search_repo_issues(conn, %{"q" => q}) do
    State.access(conn.url)
    |> case do
      :ok ->
        params = parse_params(q)
        {username, repo} = get_value("repo", params)
        state = get_value("state", params)

        data =
          case repo do
            "not-found" ->
              %{
                "message" => "Validation Failed",
                "errors" => [
                  %{
                    "message" =>
                      "The listed users and repositories cannot be searched either because the resources do not exist or you do not have permission to view them.",
                    "resource" => "Search",
                    "field" => "q",
                    "code" => "invalid"
                  }
                ],
                "documentation_url" => "https://docs.github.com/v3/search/"
              }

            _ ->
              one = one_issue(1, username, repo, state)
              two = one_issue(2, username, repo, state, true)

              %{
                "incomplete_results" => false,
                "total_count" => 1,
                "items" => [one, two]
              }
          end

        data = data |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def get_repo_issues(conn, %{"repo" => "not-found", "username" => _username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        data =
          %{
            "documentation_url" =>
              "https://docs.github.com/rest/issues/issues#list-repository-issues",
            "message" => "Not Found"
          }
          |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 404}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def get_repo_issues(conn, %{"repo" => repo, "username" => username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        one = one_issue(1, username, repo, "open")
        data = [one] |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def get_repo_contributors(conn, %{"repo" => "not-found", "username" => _username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        data =
          %{
            "documentation_url" =>
              "https://docs.github.com/rest/contributors/contributors#list-repository-contributors",
            "message" => "Not Found"
          }
          |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 404}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  def get_repo_contributors(conn, %{"repo" => _repo, "username" => username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        data = [Map.put(user(username), "contributions", 10)] |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)
    end
  end

  ###### private functions
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

  defp one_issue(number, username, repo, state, has_labels? \\ false) do
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
      "user" => user(username),
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

  defp parse_params(q) do
    String.split(q, " ")
    |> Enum.map(fn p ->
      String.split(p, ":")
      |> List.to_tuple()
      |> case do
        {"repo", username_repo} -> {"repo", username_repo |> String.split("/") |> List.to_tuple()}
        {key, value} -> {key, value}
      end
    end)
  end

  defp get_value(key, params) do
    params
    |> List.keyfind!(key, 0)
    |> elem(1)
  end

  defp response_rate_limit(url) do
    {:ok,
     %HTTPoison.Response{
       status_code: 403,
       body:
         "{\"message\":\"API rate limit exceeded for #{Faker.Internet.ip_v4_address()}. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)\",\"documentation_url\":\"https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting\"}\n",
       headers: [
         {"Server", "Varnish"},
         {"X-Content-Type-Options", "nosniff"},
         {"X-Frame-Options", "deny"},
         {"X-XSS-Protection", "1; mode=block"},
         {"Content-Security-Policy", "default-src 'none'; style-src 'unsafe-inline'"},
         {"Access-Control-Allow-Origin", "*"},
         {"Access-Control-Expose-Headers",
          "ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-RateLimit-Used, X-RateLimit-Resource, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, Deprecation, Sunset"},
         {"Content-Type", "application/json; charset=utf-8"},
         {"X-GitHub-Media-Type", "github.v3; format=json"},
         {"X-RateLimit-Limit", "60"},
         {"X-RateLimit-Remaining", "0"},
         {"X-RateLimit-Reset", "1700568818"},
         {"X-RateLimit-Resource", "core"},
         {"X-RateLimit-Used", "60"}
       ],
       request_url: url,
       request: %HTTPoison.Request{
         method: :get,
         url: url
       }
     }}
  end
end
