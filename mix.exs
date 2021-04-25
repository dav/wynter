defmodule Wynter.MixProject do
  use Mix.Project

  def project do
    [
      app: :wynter,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Wynter.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:calendar, "~> 1.0"},
      {:envy, "~> 1.1.1"},
      {:poison, "~> 4.0"},
      {:quantum, "~> 3.3"},
      {:remix, "~> 0.0.1", only: :dev},
      {:slack, "~> 0.23.5"},
      {:tzdata, "~> 1.1"},
      {:bypass, "~> 2.1"}
    ]
  end

  defp aliases do
    [
      # test: "test --no-start"
    ]
  end
end
