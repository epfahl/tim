defmodule Tim.MixProject do
  use Mix.Project

  @version "0.2.1"

  def project do
    [
      app: :tim,
      name: "Tim",
      version: @version,
      elixir: "~> 1.15",
      description: description(),
      package: package(),
      docs: docs(),
      source_url: "https://github.com/epfahl/tim",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Tim provides macros for measuring the execution time of an arbitrary Elixir expression."
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Eric Pfahl"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/epfahl/tim"
      }
    ]
  end

  defp docs() do
    [
      main: "Tim",
      extras: ["README.md"]
    ]
  end
end
