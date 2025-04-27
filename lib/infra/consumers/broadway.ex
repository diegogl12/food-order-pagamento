defmodule FoodOrderPagamento.Infra.Consumers.Broadway do
  require Logger

  use Broadway

  alias Broadway.Message
  alias FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController

  def start_link(queue_name: queue_name) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      context: queue_name,
      producer: [
        module: {BroadwaySQS.Producer, queue_url: queue_url(queue_name), config: config()}
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
  def handle_message(_processor, %Message{data: data} = message, :checkout) do
    Logger.info("Received message: #{inspect(data)}")

    result = PaymentController.request_payment(data)

    Logger.info("Message processed: result #{inspect(result)}")
    Logger.info("Message data: #{inspect(data)}")

    message
  end

  def handle_message(_, _, _), do: IO.inspect("Message queue has no handler...")
  @impl true
  def handle_batch(_, messages, _, _) do
    IO.inspect("Handling Messages:")
    IO.inspect(messages)
    IO.inspect("==================")
    messages
  end

  defp config(),
    do: [
      access_key_id:
        Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:access_key_id),
      secret_access_key:
        Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:access_key_id),
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

  defp queue_url(queue_name) do
    endpoint = Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:endpoint)
    account_id = Application.get_env(:food_order_pagamento, :aws) |> Keyword.get(:account_id)

    sqs_name =
      Application.get_env(:food_order_pagamento, :sqs)
      |> Keyword.get(queue_name)
      |> Keyword.get(:name)

    "#{endpoint}/#{account_id}/#{sqs_name}"
  end
end
