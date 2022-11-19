defmodule Tim.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :tim,
      version: @version,
      elixir: "~> 1.14",
      desription: description(),
      package: package(),
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
    []
  end

  defp description() do
    "Tim provides a macro for measuring the execution time of an arbitrary Elixir expression."
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
end
