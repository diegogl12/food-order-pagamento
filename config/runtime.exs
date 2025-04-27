import Config

config :food_order_pagamento, :sqs,
  checkout: [
    host: System.get_env("AWS_ENDPOINT"),
    name: System.get_env("CHECKOUT_SQS_NAME")
  ]

config :food_order_pagamento, :aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION"),
  endpoint: System.get_env("AWS_ENDPOINT"),
  account_id: System.get_env("AWS_ACCOUNT_ID"),
  sqs_host: System.get_env("AWS_SQS_HOST"),
  sqs_port: System.get_env("AWS_SQS_PORT")

config :food_order_pagamento, :pedidos,
  host: System.get_env("FOOD_ORDER_PEDIDOS_HOST")

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION"),
  http_client: ExAws.Request.Hackney
