defmodule FoodOrderPagamento.Infra.PagamentosRepo do
  use Ecto.Repo,
    otp_app: :food_order_pagamento,
    adapter: Ecto.Adapters.Postgres
end
