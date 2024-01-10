defmodule Gitx.Context.SchedulerContextTest do
  use Gitx.DataCase, async: false
  use Oban.Testing, engine: Oban.Engines.Lite, queues: [github: 1, webhook: 10], repo: Gitx.Repo

  alias Gitx.Context.SchedulerContext
  alias Gitx.Mock.State

  describe "Scheduler" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
      State.reset()
      :ok
    end

    test "fetch a repository" do
      workers_github = ["Gitx.Jobs.Github.FetchRepositoryJob"]
      username = "andridus"
      repository = "lx"
      expected_time = 0
      # create contributors and issues on Github Api
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)

      params = %{
        "username" => username,
        "repository" => repository
      }

      assert {:ok, _job} = SchedulerContext.to_fetch_repository(params)

      jobs_gihub = all_enqueued(queue: :github)
      assert Enum.all?(jobs_gihub, &(&1.worker in workers_github))
      assert Enum.count(workers_github) == Enum.count(jobs_gihub)

      # perform jobs
      for job <- jobs_gihub do
        assert %{worker: worker, args: args} = job

        assert {:ok, job_webhook} =
                 perform_job(Module.concat(String.split(worker, ".")), args)

        assert "scheduled" = job_webhook.state
        assert DateTime.diff(job_webhook.scheduled_at, DateTime.utc_now(), :hour) >= expected_time
      end
    end

    test "error fetch a repository - wrong params" do
      workers_github = ["Gitx.Jobs.Github.FetchRepositoryJob"]
      username = "andridus"
      repository = "lx"
      # create contributors and issues on Github Api
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)

      params = %{
        "wrong" => username,
        "repository" => repository
      }

      assert {:error, "`username` required"} = SchedulerContext.to_fetch_repository(params)

      jobs_gihub = all_enqueued(queue: :github)
      assert Enum.all?(jobs_gihub, &(&1.worker in workers_github))
      assert Enum.empty?(jobs_gihub)
    end

    test "fetch a repository and push" do
      workers_github = ["Gitx.Jobs.Github.FetchRepositoryJob"]
      workers_webhook = ["Gitx.Jobs.Webhook.PushJob"]
      username = "andridus"
      repository = "lx"

      params = %{
        "username" => username,
        "repository" => repository
      }

      # create contributors and issues on Github Api
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)
      assert {:ok, _job} = SchedulerContext.to_fetch_repository(params)

      jobs_gihub = all_enqueued(queue: :github)
      assert Enum.all?(jobs_gihub, &(&1.worker in workers_github))
      assert Enum.count(workers_github) == Enum.count(jobs_gihub)

      for job <- jobs_gihub do
        assert %{worker: worker, args: args} = job

        assert {:ok, _job_webhook} =
                 perform_job(Module.concat(String.split(worker, ".")), args)
      end

      jobs_webhook = all_enqueued(queue: :webhook)
      assert Enum.all?(jobs_webhook, &(&1.worker in workers_webhook))
      assert Enum.count(workers_webhook) == Enum.count(jobs_webhook)

      for job <- jobs_webhook do
        assert %{worker: worker, args: args} = job
        assert :ok = perform_job(Module.concat(String.split(worker, ".")), args)
      end
    end

    test "unique jobs by username and repository in 1 day" do
      workers_github = ["Gitx.Jobs.Github.FetchRepositoryJob"]
      username = "andridus"
      repository = "lx"

      params = %{
        "username" => username,
        "repository" => repository
      }

      # create contributors and issues on Github Api
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)

      for _i <- 1..10 do
        assert {:ok, _job} = SchedulerContext.to_fetch_repository(params)
      end

      jobs_gihub = all_enqueued(queue: :github)
      assert Enum.all?(jobs_gihub, &(&1.worker in workers_github))
      assert 1 == Enum.count(jobs_gihub)

      assert %{success: 1} = Oban.drain_queue(queue: :github)
    end
  end

  describe "Scheduler with rate limit" do
    setup do
      # Configure HTTPoison to use Mock Github/Swap Endpoint in the tests below
      Mimic.stub_with(HTTPoison, Gitx.Mock.Endpoint)
      State.reset()
      State.set_rate_limit(2)
      :ok
    end

    test "fetch a repository with error" do
      workers_github = ["Gitx.Jobs.Github.FetchRepositoryJob"]
      username = "andridus"
      repository = "lx"

      params = %{
        "username" => username,
        "repository" => repository
      }

      # create contributors and issues on Github Api
      :ok = State.set_contributors(username, repository, [1])
      :ok = State.set_issues(username, repository, "open", false, 1..2)
      assert {:ok, _job} = SchedulerContext.to_fetch_repository(params)

      jobs_gihub = all_enqueued(queue: :github)
      assert Enum.all?(jobs_gihub, &(&1.worker in workers_github))
      assert Enum.count(workers_github) == Enum.count(jobs_gihub)

      # perform jobs
      for job <- jobs_gihub do
        assert %{worker: worker, args: args} = job

        assert {:error, ["API rate limit" <> _]} =
                 perform_job(Module.concat(String.split(worker, ".")), args)
      end
    end
  end
end
