defmodule Lilictocat.MixProject do
  use Mix.Project

  def project do
    [
      app: :lilictocat,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tentacat, "~> 2.0"},
      {:excoveralls, "~> 0.10", only: :test},
      {:mox, "~> 0.5", only: :test}
    ]
  end
end
