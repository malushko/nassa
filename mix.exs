defmodule KV.MixProject do
  use Mix.Project

  def project do
    [
      app: :nasa,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: NASA.StartMission],
      deps: deps()
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end
