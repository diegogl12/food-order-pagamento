import Config

config :food_order_pagamento, :api,
  port: System.get_env("FOOD_ORDER_PAGAMENTO_ENDPOINT_PORT", "4000") |> String.to_integer() 

import_config "#{config_env()}.exs"

