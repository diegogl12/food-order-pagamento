defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Mercadopago do
  @behaviour FoodOrderPagamento.InterfaceAdapters.Gateways.PaymentGatewayBehaviour

  alias FoodOrderPagamento.Domain.Entities.Checkout

  @impl true
  def perform_payment(%Checkout{} = checkout) do
    payment_data = %{
      transaction_amount: checkout.amount,
      description: "Order #{checkout.order_id}"
    }

    {:ok, %{payment_id: UUID.uuid1()}}
  end
end
