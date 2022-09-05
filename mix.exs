defmodule Ymlr.MixProject do
  use Mix.Project

  @source_url "https://github.com/ufirstgroup/ymlr"
  @version "3.0.1"

  def project do
    [
      app: :ymlr,
      description: "A YAML encoder for Elixir",
      version: @version,
      elixir: "~> 1.10",
      deps: deps(),
      dialyzer: dialyzer(),
      package: package(),
      preferred_cli_env: cli_env(),
      test_coverage: [
        tool: ExCoveralls
      ],
      test_paths: ["lib"],
      docs: [
        main: "readme",
        extras: ["README.md", "usage.livemd", "CHANGELOG.md"],
        source_ref: "v#{@version}",
        source_url: @source_url
      ]

    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.travis": :test,
      "coveralls.github": :test,
      "coveralls.xml": :test,
      "coveralls.json": :test,
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5-pre", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: [:test]},
      {:ex_doc, "~> 0.20", only: :dev},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.4", only: [:test]},
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      plt_add_apps: [:mix, :eex],
      plt_core_path: "priv/plts",
      plt_local_path: "priv/plts",
    ]
  end

  defp package do
    [
      name: :ymlr,
      maintainers: ["Michael Ruoss", "Jean-Luc Geering"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG.md"]
    ]
  end
end
