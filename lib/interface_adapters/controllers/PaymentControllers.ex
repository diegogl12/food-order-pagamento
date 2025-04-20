defmodule FoodOrderPagamento.InterfaceAdapters.Controllers.PaymentController do
  alias FoodOrderPagamento.InterfaceAdapters.Gateways.DTOs.CheckoutDTO
  alias FoodOrderPagamento.InterfaceAdapters.Gateways.Clients.Mercadopago
  alias FoodOrderPagamento.InterfaceAdapters.Repositories.PaymentRepository
  alias FoodOrderPagamento.UseCases.RequestPayment

  def request_payment(checkout_json) do
    with {:ok, checkout_dto} <- CheckoutDTO.from_json(checkout_json),
         {:ok, checkout} <- CheckoutDTO.to_domain(checkout_dto) do
      RequestPayment.execute(checkout, Mercadopago, PaymentRepository)
    end
  end
end
