import Config

config :food_order_pagamento, :api, port: 4000

config :food_order_pagamento, FoodOrderPagamento.Infra.PagamentosRepo,
  database: "food_order_pagamento_repo",
  username: "postgres",
  password: "postgres",
  hostname: "food_order_database"
