defmodule FoodOrderPagamento.Broadway do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwaySQS.Producer,
          queue_url: queue_url(),
          config: config()
        }
      ],
      processors: [
        default: []
      ],
      batchers: [
        default: [
          batch_size: 10,
          batch_timeout: 2000
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{} = message, _) do
    IO.inspect("Handling Message:")
    IO.inspect(message)
    IO.inspect("=================")
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    IO.inspect("Handling Messages:")
    IO.inspect(messages)
    IO.inspect("==================")
    messages
  end

  defp config(), do: [
    access_key_id: Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:access_key_id),
    secret_access_key: Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:access_key_id),
    region: Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:region),
    scheme: "http",
    host: Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:sqs_host),
    port: Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:sqs_port),
    http_client_opts: [
      timeout: 30_000,
      recv_timeout: 30_000,
      hackney: [pool: false]
    ]
  ]

  defp queue_url do
    endpoint = Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:endpoint) 
    account_id = Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:account_id)
    sqs_name = Application.get_env(:food_order_pagamento, :sqs) |> Keyword.get(:novo_pedido) |> Keyword.get(:name) 

    "#{endpoint}/#{account_id}/#{sqs_name}"
  end
end
