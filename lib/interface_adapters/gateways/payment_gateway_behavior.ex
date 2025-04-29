defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.PaymentGatewayBehaviour do
  alias FoodOrderPagamento.Domain.Entities.Checkout
  alias FoodOrderPagamento.Domain.Entities.Payment

  @callback perform_payment(Checkout.t()) :: {:ok, Payment.t()} | {:error, any()}
end
