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
            State.one_user(username),
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

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
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

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
    end
  end

  def get_repo(conn, %{"repo" => repo, "username" => username}) do
    State.access(conn.url)
    |> case do
      :ok ->
        data =
          State.one_repo(username, repo)
          |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
    end
  end

  def search_repo_issues(conn, %{"q" => q}) do
    State.access(conn.url)
    |> case do
      :ok ->
        params = parse_params(q)
        {_username, repo} = get_value("repo", params)
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
              issues = State.all_issues(repo, state, {50_000, 1})

              %{
                "incomplete_results" => false,
                "total_count" => length(issues),
                "items" => issues
              }
          end

        data = data |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
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

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
    end
  end

  def get_repo_issues(conn, %{"repo" => repo, "username" => _username} = params) do
    State.access(conn.url)
    |> case do
      :ok ->
        per_page = (params["per_page"] || "30") |> String.to_integer()
        page = (params["page"] || "1") |> String.to_integer()

        data = State.all_issues(repo, "open", {per_page, page}) |> Jason.encode!()

        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
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

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
    end
  end

  def get_repo_contributors(conn, %{"repo" => repo, "username" => _username} = params) do
    State.access(conn.url)
    |> case do
      :ok ->
        per_page = (params["per_page"] || "30") |> String.to_integer()
        page = (params["page"] || "1") |> String.to_integer()

        data = State.all_contributors(repo, {per_page, page}) |> Jason.encode!()
        {:ok, %HTTPoison.Response{body: data, status_code: 200}}

      :rate_limit ->
        response_rate_limit(conn.url)

      :nxdomain ->
        {:error, %HTTPoison.Error{reason: :nxdomain}}
    end
  end

  ###### private functions
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
