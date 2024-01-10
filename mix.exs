defmodule Gitx.MixProject do
  use Mix.Project

  def project do
    [
      app: :gitx,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [
        ignore_modules: [
          Gitx.Application,
          GitxWeb.Gettext,
          GitxWeb.Router,
          GitxWeb.Endpoint,
          GitxWeb.Telemetry,
          GitxWeb.ConnCase,
          Gitx.Fixtures,
          Gitx.External.Api,
          Gitx.External.Github.Api,
          Gitx.Mock.GithubFunctions,
          Gitx.StructCase,
          Gitx.Mock.State,
          Gitx.Repo
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Gitx.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # phoenix
      {:phoenix, "~> 1.7.10"},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:plug_cowboy, "~> 2.5"},
      # libs extra
      {:httpoison, "~> 2.0"},
      {:oban, "~> 2.16"},
      {:phoenix_ecto, "~> 4.4"},
      # test
      {:faker, "~> 0.17", only: :test},
      {:mix_test_watch, "~> 1.0", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:httpmock, "~> 0.1.5", only: :test},
      {:mimic, "~> 1.7", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
