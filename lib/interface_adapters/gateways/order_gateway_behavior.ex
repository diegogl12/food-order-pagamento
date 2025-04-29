defmodule FoodOrderPagamento.InterfaceAdapters.Gateways.OrderGatewayBehavior do
  alias FoodOrderPagamento.Domain.Entities.Payment
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  @callback update_payment_status(Payment.t(), PaymentStatus.t()) :: :ok | {:error, any()}
end
