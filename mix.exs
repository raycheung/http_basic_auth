defmodule HttpBasicAuth.Mixfile do
  use Mix.Project

  def project do
    [app: :http_basic_auth,
     description: "HTTP Basic Authentication Plug",
     package: package,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.0"}]
  end

  defp package do
    %{contributors: ["Ray Cheung"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/raycheung/http_basic_auth"},
      files: ~w(lib mix.exs README.md)}
  end
end
