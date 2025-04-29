defmodule FoodOrderPagamento.UseCases.RequestPayment do
  require Logger

  alias FoodOrderPagamento.Domain.Entities.Checkout
  alias FoodOrderPagamento.Domain.Entities.PaymentStatus

  def execute(
        %Checkout{} = checkout,
        payment_provider,
        payment_repository,
        payment_status_repository
      ) do
    with {:ok, payment_response} <- payment_provider.perform_payment(checkout),
         {:ok, saved_payment} <- payment_repository.create(payment_response),
         {:ok, _} <-
           payment_status_repository.create(%PaymentStatus{
             payment_id: saved_payment.id,
             status: "Pagamento Pendente"
           }) do
      Logger.info("Payment processed and saved successfully with ID: #{saved_payment.id}")

      {:ok, saved_payment}
    else
      {:error, error} = result ->
        Logger.error("Payment failed with error: #{inspect(error)}")
        result
    end
  end
end
