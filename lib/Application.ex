defmodule FoodOrderPagamento.Application do
  use Application
  require Logger

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: FoodOrderPagamento.Supervisor]

    Logger.info("The server has started at port #{port()}...")

    Supervisor.start_link(children(Mix.env()), opts)
  end

  defp children(:test), do: []
  defp children(_), do: [
    FoodOrderPagamento.Infra.PagamentosRepo,
    {Plug.Cowboy, scheme: :http, plug: FoodOrderPagamento.Infra.Web.Endpoints, options: [port: port()]},
    {FoodOrderPagamento.Infra.Consumers.Broadway, [queue_name: :checkout]}
  ]

  defp port, do: Application.get_env(:food_order_pagamento, :api) |> Keyword.get(:port)
end
