defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Mercadopago do
  @behaviour FoodOrderPagamento.InterfaceAdapters.Gateways.PaymentGatewayBehaviour

  alias FoodOrderPagamento.Domain.Entities.Checkout
  alias FoodOrderPagamento.InterfaceAdapters.DTOs.MercadopagoResponseDTO

  @impl true
  def perform_payment(%Checkout{} = checkout) do
    payment_data = %MercadopagoResponseDTO{
      payment_id: UUID.uuid1(),
      transaction_amount: checkout.amount,
      description: "Order #{checkout.order_id}",
      payment_date: NaiveDateTime.utc_now(),
      payment_method: checkout.payment_method,
      created_at: NaiveDateTime.utc_now()
    }

    {:ok, MercadopagoResponseDTO.to_payment(payment_data, checkout)}
  end
end
