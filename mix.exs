defmodule Lilictocat.MixProject do
  use Mix.Project

  @description "Lilictocat is a simple pull request filter."
  @version "0.1.3"

  def project do
    [
      app: :lilictocat,
      name: "Lilictocat",
      version: @version,
      description: @description,
      package: package(),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      source_url: "https://github.com/volcov/lilictocat",
      docs: [extras: ["README.md"], main: "Lilictocat", assets: "assets"]
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
      {:mox, "~> 0.5", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      maintainers: ["Bruno Volcov"],
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      links: %{
        "GitHub" => "https://github.com/volcov/lilictocat"
      }
    ]
  end
end
