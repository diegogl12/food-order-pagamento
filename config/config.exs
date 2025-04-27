import Config

config :food_order_pagamento, FoodOrderPagamento.Infra.PagamentosRepo,
  database: System.get_env("FOOD_ORDER_PAGAMENTO_DATABASE", "food_order_pagamento_repo"),
  username: System.get_env("FOOD_ORDER_PAGAMENTO_USERNAME", "postgres"),
  password: System.get_env("FOOD_ORDER_PAGAMENTO_PASSWORD", "postgres"),
  hostname: System.get_env("FOOD_ORDER_PAGAMENTO_HOSTNAME", "food_order_database"),
  migration_primary_key: [type: :uuid]

config :food_order_pagamento, ecto_repos: [FoodOrderPagamento.Infra.PagamentosRepo]

config :food_order_pagamento, :api,
  port: System.get_env("FOOD_ORDER_PAGAMENTO_ENDPOINT_PORT", "4000") |> String.to_integer()

config :tesla, :adapter, Tesla.Adapter.Mint

import_config "#{config_env()}.exs"
