import Config

config :food_order_pagamento, :api, port: 4000

config :food_order_pagamento, FoodOrderPagamento.Infra.PagamentosRepo,
  database: "foodorder_pagamento_db",
  username: "postgres",
  password: "postgres",
  hostname: "postgres"
