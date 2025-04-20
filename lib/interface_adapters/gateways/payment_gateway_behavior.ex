defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.PaymentGatewayBehaviour do
  alias FoodOrderPagamento.Domain.Entities.Checkout

  @callback perform_payment(Checkout.t()) :: {:ok, map()} | {:error, any()}
end
