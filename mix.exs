defmodule FoodOrderPagamento.MixProject do
  use Mix.Project

  def project do
    [
      app: :food_order_pagamento,
      version: "0.1.0",
      elixir: "~> 1.18-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {FoodOrderPagamento.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:broadway_sqs, "~> 0.7"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_sqs, "~> 3.0"},
      {:hackney, "~> 1.9"},
      {:jason, "~> 1.4.4"},
      {:mint, "~> 1.0"},
      {:plug_cowboy, "~> 2.7.3"},
      {:req, "~> 0.4.0"},
      {:tesla, "~> 1.14"},
      {:uuid, "~> 1.1"}
    ]
  end
end
