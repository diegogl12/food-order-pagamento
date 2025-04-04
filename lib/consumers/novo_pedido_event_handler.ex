defmodule FoodOrderPagamento.Consumers.NovoPedidoEventHandler do
  def run(message) do
    IO.inspect("Processing message...")
    IO.inspect(message)
    IO.inspect("Message processed!")

    :ok
  end
end
